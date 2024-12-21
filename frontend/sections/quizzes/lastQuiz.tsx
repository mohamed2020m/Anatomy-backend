'use client';

import * as React from 'react';
import { useState,useEffect} from 'react';
import { zodResolver } from '@hookform/resolvers/zod';
import { useForm } from 'react-hook-form';
import * as z from 'zod';
import { Button } from '@/components/ui/button';
import { Label } from '@/components/ui/label';
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage
} from '@/components/ui/form';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue
} from '@/components/ui/select';
import { Input } from '@/components/ui/input';
import { Card, CardHeader, CardTitle, CardContent, CardFooter } from '@/components/ui/card';
import { Textarea } from '@/components/ui/textarea';
import { toast } from '@/components/ui/use-toast';
import { useSession } from 'next-auth/react';
import { useRouter } from 'next/navigation';
import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger
} from '@/components/ui/accordion';
import { Progress } from '@/components/ui/progress';
import { Question } from '@/constants/data';

const API_URL = `${process.env.NEXT_PUBLIC_BACKEND_API}/api/v1`;
const MODEL_API = `${process.env.NEXT_PUBLIC_MODEL_API}`;

const formSchema = z.object({
  title: z.string().min(2, {
    message: 'Title must be at least 2 characters.'
  }),
  description: z
    .string({
      required_error: 'Please select quiz description.'
    })
    .max(255, {
      message: 'Description must not be more than 255 characters.'
    })
});

export default function QuizCreationWorkflow() {
  const { data: session } = useSession();
  const router = useRouter();
  
  // State for multi-step workflow
  const [currentStep, setCurrentStep] = useState(1);
  const [progress, setProgress] = useState(33);

  // State for Step 1: File and Quiz Generation
  const [categories, setCategories] = useState<{ id: number; name: string }[]>([]);
  const [selectedCategory, setSelectedCategory] = useState<{ id: number; name: string } | null>(null);
  const [file, setFile] = useState<File | null>(null);
  const [selectedNumber, setSelectedNumber] = useState<number | string>('5');

  // State for Step 2: Generated Questions
  const [questions, setQuestions] = useState<Question[]>([]);

  // Form for quiz details
  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      title: '',
      description: ''
    }
  });

  // Ajout du useEffect pour fetcher les catégories
  useEffect(() => {
    const fetchCategories = async () => {
      if (!session) return; // Ensure session is available
      try {
        const response = await fetch(
          `${API_URL}/professors/${session?.user.id}/sub-categories`,
          {
            headers: {
              Authorization: `Bearer ${session?.user.access_token}`,
              'Content-Type': 'application/json'
            }
          }
        );
        const data = await response.json();
        setCategories(data);
      } catch (error) {
        toast({
          title: 'Error',
          description: 'Failed to fetch categories.',
          variant: 'destructive'
        });
      }
    };
    fetchCategories();
  }, [session]);

  const handleCategorySelect = (
    category: { id: number; name: string } | null
  ) => {
    setSelectedCategory(category);
  };


  // Step 1: File Upload and Quiz Generation
  async function generateQuiz(data: { file: File; num_questions: number }) {
    if (!data.file) {
      toast({
        title: 'Error',
        description: 'File is required.',
        variant: 'destructive'
      });
      throw new Error('File is required');
    }

    const formData = new FormData();
    formData.append('file', data.file);
    formData.append('num_questions', String(data.num_questions));

    try {
      const response = await fetch(`${MODEL_API}/generate-quiz`, {
        method: 'POST',
        body: formData
      });

      if (!response.ok) {
        const errorMessage = await response.text();
        toast({
          title: 'Error',
          description: errorMessage || 'Failed to generate quiz',
          variant: 'destructive'
        });
        throw new Error(errorMessage || 'Failed to generate quiz');
      }

      toast({
        title: 'Success',
        description: 'Quiz generated successfully',
        variant: 'success'
      });

      return await response.json();
    } catch (error) {
      toast({
        title: 'Error',
        description: (error as Error)?.message || 'Something went wrong',
        variant: 'destructive'
      });
      throw error;
    }
  }

  // Handle Generate Quiz Click
  const handleGenerateQuizClick = async () => {
    if (!file) {
      toast({
        title: 'Error',
        description: 'Please upload a file.',
        variant: 'destructive'
      });
      return;
    }

    if (!selectedNumber) {
      toast({
        title: 'Error',
        description: 'Please select the number of questions.',
        variant: 'destructive'
      });
      return;
    }

    try {
      const responseQuiz = await generateQuiz({
        file: file,
        num_questions: Number(selectedNumber)
      });

      setQuestions(responseQuiz);
      // Move to next step
      setCurrentStep(2);
      setProgress(66);
    } catch (error) {
      console.error('Error generating quiz:', error);
    }
  };

  // Final Submit
  async function onSubmit(values: z.infer<typeof formSchema>) {
    try {
      const access_token = session?.user.access_token;
      if (!access_token) {
        throw new Error('Unauthorized');
      }

      if (!selectedCategory) {
        throw new Error('Please select a category.');
      }

      const quizData = {
        title: values.title,
        description: values.description,
        subCategory: { id: selectedCategory.id },
        questions: questions
      };

      const res = await fetch(`${API_URL}/quizzes`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${access_token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(quizData)
      });

      if (!res.ok) {
        throw new Error('Failed to create quiz');
      }

      const result = await res.json();

      toast({
        title: 'Success',
        description: result.message,
        variant: 'success'
      });

      // Move to final step and complete progress
      setCurrentStep(3);
      setProgress(100);

      // Redirect after a short delay
      setTimeout(() => {
        router.back();
      }, 1500);

    } catch (error) {
      toast({
        title: 'Error',
        description: (error as Error)?.message || 'Failed to create quiz.',
        variant: 'destructive'
      });
    }
  }

  // Render steps
  const renderStep = () => {
    switch (currentStep) {
      case 1:
        return (
          <div className="space-y-6">
            <div className="grid w-full max-w-sm items-center gap-1.5">
              <Label htmlFor="file">PDF document</Label>
              <Input
                id="file"
                type="file"
                onChange={(e) =>
                  setFile(e.target.files ? e.target.files[0] : null)
                }
              />
            </div>

            <div className="flex flex-col gap-2">
              <label className="text-sm font-medium">
                Select number of questions
              </label>
              <Select 
                value={String(selectedNumber)} 
                onValueChange={(value) => setSelectedNumber(value)}
              >
                <SelectTrigger className="w-[120px]">
                  <SelectValue>{selectedNumber || '5'}</SelectValue>
                </SelectTrigger>
                <SelectContent>
                  {[5, 10, 15, 20].map((num) => (
                    <SelectItem key={num} value={String(num)}>
                      {num}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            <Button onClick={handleGenerateQuizClick}>
              Generate Quiz
            </Button>
          </div>
        );
      
      case 2:
        return (
          <div>
            <Accordion type="single" collapsible className="w-full">
              {questions.map((q, index) => (
                <AccordionItem key={index} value={`item-${index}`}>
                  <AccordionTrigger>{q.questionText}</AccordionTrigger>
                  <AccordionContent>
                    <div>
                      <strong>Options:</strong>
                      <ul>
                        <li><strong>A:</strong> {q.options.A}</li>
                        <li><strong>B:</strong> {q.options.B}</li>
                        <li><strong>C:</strong> {q.options.C}</li>
                        <li><strong>D:</strong> {q.options.D}</li>
                      </ul>
                      <strong>Correct Answer:</strong> {q.correctAnswer.replace('option_', '').toUpperCase()}
                      <br />
                      <strong>Explanation:</strong> {q.explanation}
                    </div>
                  </AccordionContent>
                </AccordionItem>
              ))}
            </Accordion>
            <div className="mt-4 flex justify-between">
              <Button 
                variant="outline" 
                onClick={() => {
                  setCurrentStep(1);
                  setProgress(33);
                }}
              >
                Back
              </Button>
              <Button 
                onClick={() => {
                  setCurrentStep(3);
                  setProgress(100);
                }}
              >
                Proceed to Details
              </Button>
            </div>
          </div>
        );
      
      case 3:
        return (
          <Form {...form}>
            <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-8">
              <FormField
                control={form.control}
                name="title"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Title</FormLabel>
                    <FormControl>
                      <Input placeholder="Enter the quiz title" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="description"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Description</FormLabel>
                    <FormControl>
                      <Textarea
                        placeholder="Enter the quiz description"
                        className="resize-none"
                        {...field}
                      />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <div className="flex flex-col gap-2">
                <label className="text-sm font-medium">Select Category</label>
                <Select
                  onValueChange={(value) =>
                    setSelectedCategory(
                      categories.find((cat) => cat.name === value) || null
                    )
                  }
                >
                  <SelectTrigger className="w-[280px]">
                    <SelectValue>
                      {selectedCategory?.name || 'Select category...'}
                    </SelectValue>
                  </SelectTrigger>
                  <SelectContent>
                    {categories &&
                      categories.map((category) => (
                        <SelectItem key={category.id} value={category.name}>
                          {category.name}
                        </SelectItem>
                      ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="flex justify-between">
                <Button 
                  type="button" 
                  variant="outline" 
                  onClick={() => {
                    setCurrentStep(2);
                    setProgress(66);
                  }}
                >
                  Back
                </Button>
                <Button type="submit">Submit Quiz</Button>
              </div>
            </form>
          </Form>
        );
      default:
        return null;
    }
  };

  return (
    <Card className="mx-auto w-full max-w-2xl">
      <CardHeader>
        <CardTitle className="text-left text-2xl font-bold">
          Quiz Creation Workflow
        </CardTitle>
        <Progress value={progress} className="w-full" />
      </CardHeader>
      <CardContent>
        {renderStep()}
      </CardContent>
    </Card>
  );
}