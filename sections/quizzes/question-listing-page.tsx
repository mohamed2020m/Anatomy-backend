'use client';

import * as React from 'react';
import { useEffect, useState } from 'react';
import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger
} from '@/components/ui/accordion';
import { Question } from '@/constants/data';
import { useSession } from 'next-auth/react';
import { useRouter } from 'next/navigation';
import { toast } from '@/components/ui/use-toast';
import { Heading } from '@/components/ui/heading';
import { Separator } from '@/components/ui/separator';
import Link from 'next/link';
import { ListIcon, Plus } from 'lucide-react';
import { buttonVariants } from '@/components/ui/button';
import { cn } from '@/lib/utils';

const APP_URL = `${process.env.NEXT_PUBLIC_BACKEND_API}/api/v1`;

const QuestionShow = ({ quizId }: { quizId: number }) => {
  const { data: session } = useSession();
  const [isLoading, setIsLoading] = useState(true);
  const router = useRouter();
  const [questions, setQuestions] = useState<Question[]>([]);
  const [questionsCount, setQuestionsCount] = useState(0);

  useEffect(() => {
    const fetchQuiz = async () => {
      const token = session?.user?.access_token;
      if (!token) {
        toast({
          title: 'Error',
          description: 'Unauthorized.',
          variant: 'destructive'
        });
        return;
      }

      try {
        const response = await fetch(
          `http://localhost:8080/api/v1/quizzes/${quizId}`,
          {
            method: 'GET',
            headers: {
              Authorization: `Bearer ${token}`,
              'Content-Type': 'application/json'
            }
          }
        );

        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const data = await response.json();
        console.log('API Response:', data.questions);
        setQuestions(data.questions);
        setQuestionsCount(data.questions.length)
      } catch (error) {
        toast({
          title: 'Error',
          description: (error as Error).message || 'Failed to fetch questions.',
          variant: 'destructive'
        });
      }
    };

    fetchQuiz();
  }, []);

  return (
    <>
      <div className="flex items-start justify-between">
        <Heading
          title={`Questions (${questionsCount})`}
          description="Display the quiz questions"
        />

        <Link
          href={'/prof/quiz'}
          className={cn(buttonVariants({ variant: 'default' }))}
        >
          <ListIcon className="mr-2 h-4 w-4" /> Quiz List
        </Link>
      </div>
      <Accordion type="single" collapsible className="w-full">
        {questions.map((q, index) => (
          <AccordionItem key={index} value={`item-${index}`}>
            <AccordionTrigger>{q.questionText}</AccordionTrigger>
            <AccordionContent>
              <div>
                <strong>Options:</strong>
                <ul>
                  <li>
                    <strong>A:</strong> {q.options.A}
                  </li>
                  <li>
                    <strong>B:</strong> {q.options.B}
                  </li>
                  <li>
                    <strong>C:</strong> {q.options.C}
                  </li>
                  <li>
                    <strong>D:</strong> {q.options.D}
                  </li>
                </ul>
                <strong>Correct Answer:</strong>{' '}
                {q.correctAnswer.replace('option_', '').toUpperCase()}
                <br />
                <strong>Explanation:</strong> {q.explanation}
              </div>
            </AccordionContent>
          </AccordionItem>
        ))}
      </Accordion>
    </>
  );
};

export default QuestionShow;
