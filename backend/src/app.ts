import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import authRoutes from './routes/auth';
import settingsRoutes from './routes/settings';
import musicRoutes from './routes/music';
import mapRoutes from './routes/map';
import weatherRoutes from './routes/weather';
import aiRoutes from './routes/ai';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/settings', settingsRoutes);
app.use('/api/music', musicRoutes);
app.use('/api/map', mapRoutes);
app.use('/api/weather', weatherRoutes);
app.use('/api/ai', aiRoutes);

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
