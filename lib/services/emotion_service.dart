import 'dart:convert';
import 'dart:io';

class EmotionResult {
  final String label;
  final double score;

  EmotionResult(this.label, this.score);
}

class EmotionService {
  // Simple rule-based sentiment as fallback
  static final List<String> _positive = [
    'good', 'happy', 'great', 'joy', 'love', 'awesome', 'calm', 'relaxed', 'relief', 'better', 'fine'
  ];
  static final List<String> _negative = [
    'sad', 'angry', 'bad', 'upset', 'depressed', 'stress', 'anx', 'anxiety', 'tired', 'fatigue'
  ];

  Future<EmotionResult> analyzeText(String text) async {
    text = text.toLowerCase();
    // Try Hugging Face inference if API key provided
    final hfKey = Platform.environment['HF_API_KEY'];
    if (hfKey != null && hfKey.isNotEmpty) {
      try {
        final uri = Uri.parse('https://api-inference.huggingface.co/models/cardiffnlp/tweet-xlm-roberta-base-sentiment');
        final client = HttpClient();
        final req = await client.postUrl(uri);
        req.headers.set('Authorization', 'Bearer $hfKey');
        req.headers.set('Accept', 'application/json');
        req.headers.contentType = ContentType.json;
        req.add(utf8.encode(jsonEncode({'inputs': text})));
        final resp = await req.close();
        final body = await resp.transform(utf8.decoder).join();
        client.close();
        if (resp.statusCode == 200) {
          final j = jsonDecode(body);
          if (j is List && j.isNotEmpty) {
            final best = j[0];
            return EmotionResult(best['label'] ?? 'neutral', (best['score'] ?? 0.0) + 0.0);
          }
        }
      } catch (_) {}
    }

    // Fallback rule-based
    int pos = 0, neg = 0;
    for (final w in _positive) {
      if (text.contains(w)) pos++;
    }
    for (final w in _negative) {
      if (text.contains(w)) neg++;
    }
    if (pos == 0 && neg == 0) return EmotionResult('neutral', 0.5);
    final label = pos >= neg ? 'positive' : 'negative';
    final score = (pos + 1) / (pos + neg + 2);
    return EmotionResult(label, score);
  }

  /// Analyze text plus a vocal-level proxy to produce a combined emotion result.
  /// [vocalLevel] is a raw amplitude/proxy (device-dependent). We normalize
  /// it heuristically and combine semantic and vocal signals.
  Future<EmotionResult> analyzeDual(String text, double vocalLevel, {double semanticWeight = 0.75}) async {
    final semantic = await analyzeText(text);
    // normalize vocalLevel: assume typical range up to ~30; clamp
    final norm = (vocalLevel / 30.0).clamp(0.0, 1.0);
    // vocal valence proxy: quiet -> calm/neutral (0.5), loud -> higher arousal;
    // map to [0,1] where >0.6 leans positive arousal
    final vocalScore = (0.5 + (norm - 0.3)).clamp(0.0, 1.0);
    final combined = (semanticWeight * semantic.score) + ((1 - semanticWeight) * vocalScore);
    final label = combined >= 0.6 ? 'positive' : 'negative';
    return EmotionResult(label, combined);
  }
}
