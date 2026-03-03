import { Request, Response } from 'express';
import { ChatOpenAI } from '@langchain/openai';
import { HumanMessage } from 'langchain/schema';

const llm = new ChatOpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

export const chat = async (req: Request, res: Response) => {
  const { message } = req.body;

  try {
    const response = await llm.invoke([new HumanMessage(message)]);
    res.json(response);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'An error occurred while processing your request.' });
  }
};
