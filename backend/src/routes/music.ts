import express, { Request, Response, Router } from 'express';
import prisma from '../utils/prisma';

const router: Router = express.Router();

// Get all songs
router.get('/', async (req: Request, res: Response) => {
  try {
    const songs = await prisma.song.findMany();
    res.json(songs);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch songs' });
  }
});

// Get a specific song by ID
router.get('/:id', async (req: Request, res: Response) => {
  const { id } = req.params;
  try {
    const song = await prisma.song.findUnique({
      where: { id },
    });
    if (!song) {
      return res.status(404).json({ error: 'Song not found' });
    }
    res.json(song);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch the song' });
  }
});

// Create a new song
router.post('/', async (req: Request, res: Response) => {
  const {
    title,
    artist,
    assetPath,
    genres,
    languages,
    moods,
    weatherTriggers,
    idealTimeRanges,
  } = req.body;
  try {
    const newSong = await prisma.song.create({
      data: {
        title,
        artist,
        assetPath,
        genres,
        languages,
        moods,
        weatherTriggers,
        idealTimeRanges,
      },
    });
    res.status(201).json(newSong);
  } catch (error) {
    res.status(500).json({ error: 'Failed to create the song' });
  }
});

// Update a song by ID
router.put('/:id', async (req: Request, res: Response) => {
  const { id } = req.params;
  const {
    title,
    artist,
    assetPath,
    genres,
    languages,
    moods,
    weatherTriggers,
    idealTimeRanges,
  } = req.body;
  try {
    const updatedSong = await prisma.song.update({
      where: { id },
      data: {
        title,
        artist,
        assetPath,
        genres,
        languages,
        moods,
        weatherTriggers,
        idealTimeRanges,
      },
    });
    res.json(updatedSong);
  } catch (error) {
    res.status(500).json({ error: 'Failed to update the song' });
  }
});

// Delete a song by ID
router.delete('/:id', async (req: Request, res: Response) => {
  const { id } = req.params;
  try {
    await prisma.song.delete({
      where: { id },
    });
    res.status(204).send();
  } catch (error) {
    res.status(500).json({ error: 'Failed to delete the song' });
  }
});

export default router;