import { Router } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import prisma from '../utils/prisma';

const router = Router();
const JWT_SECRET = process.env.JWT_SECRET || 'climora_secret_key_2024';

// Register
router.post('/register', async (req, res) => {
    try {
        const { email, password, name } = req.body;

        const existing = await prisma.user.findUnique({ where: { email } });
        if (existing) return res.status(400).json({ error: 'User already exists' });

        const hashedPassword = await bcrypt.hash(password, 10);
        const user = await prisma.user.create({
            data: {
                email,
                password: hashedPassword,
                name,
                settings: {
                    create: {
                        timeRanges: 'morning,afternoon,evening,night',
                        weatherTriggers: 'sunny,cloudy,rainy,clear'
                    }
                }
            }
        });

        res.status(201).json({ message: 'User created', userId: user.id });
    } catch (err: any) {
        res.status(500).json({ error: err.message });
    }
});

// Login
router.post('/login', async (req, res) => {
    try {
        const { email, password } = req.body;
        const user = await prisma.user.findUnique({ where: { email } });

        if (!user || !(await bcrypt.compare(password, user.password))) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        const token = jwt.sign({ userId: user.id }, JWT_SECRET, { expiresIn: '7d' });
        res.json({ token, user: { id: user.id, email: user.email, name: user.name } });
    } catch (err: any) {
        res.status(500).json({ error: err.message });
    }
});

export default router;
