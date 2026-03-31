
import express, { Router, Request, Response } from 'express';

const router: Router = express.Router();

// Sample location data
const recommendations = [
  {
    "name": "The Friendly Toast",
    "type": "Restaurant",
    "address": "121 Kendall St, Cambridge, MA 02142"
  },
  {
    "name": "Cambridge Brewing Company",
    "type": "Brewery",
    "address": "1 Kendall Square, Cambridge, MA 02139"
  },
  {
    "name": "Lamplighter Brewing Co.",
    "type": "Brewery",
    "address": "284 Broadway, Cambridge, MA 02139"
  }
];

router.get('/recommendations', (req: Request, res: Response) => {
  res.json(recommendations);
});

export default router;
