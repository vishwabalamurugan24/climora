import { Router } from 'express';
import prisma from '../utils/prisma';
import { authenticate } from '../middleware/auth';

const router = Router();

// Get settings
router.get('/', authenticate, async (req: any, res) => {
    try {
        const settings = await prisma.userSettings.findUnique({
            where: { userId: req.user.userId }
        });
        res.json(settings);
    } catch (err: any) {
        res.status(500).json({ error: err.message });
    }
});

// Update settings
router.post('/sync', authenticate, async (req: any, res) => {
    try {
        const { timeRanges, weatherTriggers } = req.body;
        const settings = await prisma.userSettings.upsert({
            where: { userId: req.user.userId },
            update: { timeRanges, weatherTriggers },
            create: { userId: req.user.userId, timeRanges, weatherTriggers }
        });
        res.json(settings);
    } catch (err: any) {
        res.status(500).json({ error: err.message });
    }
});

export default router;
