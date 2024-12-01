'use client';

import * as React from 'react';
import { useState, useEffect } from 'react';
import { zodResolver } from '@hookform/resolvers/zod';
import { useForm, useFieldArray } from 'react-hook-form';
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

// Extend the question schema to include editable fields
const questionSchema = z.object({
  questionText: z.string().min(1, "Question text is required"),
  options: z.object({
    A: z.string().min(1, "Option A is required"),
    B: z.string().min(1, "Option B is required"),
    C: z.string().min(1, "Option C is required"),
    D: z.string().min(1, "Option D is required")
  }),
  correctAnswer: z.enum(['option_a', 'option_b', 'option_c', 'option_d'], {
    required_error: "Correct answer must be selected"
  }),
  explanation: z.string().optional()
});

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
    }),
  questions: z.array(questionSchema)
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

  // Form for quiz details with question editing
  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      title: '',
      description: '',
      questions: []
    }
  });

  // Fetch categories on session change
  useEffect(() => {
    const fetchCategories = async () => {
      if (!session) return;
      try {
        const response = await fetch(
          `${process.env.NEXT_PUBLIC_BACKEND_API}/api/v1/professors/${session?.user.id}/sub-categories`,
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
      const response = await fetch('http://localhost:8000/generate-quiz', {
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
      
      // Populate form with generated questions
      form.setValue('questions', responseQuiz.map(q => ({
        questionText: q.questionText,
        options: q.options,
        correctAnswer: q.correctAnswer,
        explanation: q.explanation || ''
      })));

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
        questions: values.questions
      };

      const res = await fetch(`${process.env.NEXT_PUBLIC_BACKEND_API}/api/v1/quizzes`, {
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
        // ... (keep the existing Step 1 implementation)
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
          <Form {...form}>
            <form>
              <Accordion type="single" collapsible className="w-full">
                {form.watch('questions').map((q, index) => (
                  <AccordionItem key={index} value={`item-${index}`}>
                    <AccordionTrigger>Question {index + 1}</AccordionTrigger>
                    <AccordionContent>
                      <div className="space-y-4">
                        <FormField
                          control={form.control}
                          name={`questions.${index}.questionText`}
                          render={({ field }) => (
                            <FormItem>
                              <FormLabel>Question Text</FormLabel>
                              <FormControl>
                                <Textarea 
                                  {...field} 
                                  placeholder="Enter question text"
                                  className="resize-y" 
                                />
                              </FormControl>
                              <FormMessage />
                            </FormItem>
                          )}
                        />

                        <div className="grid grid-cols-2 gap-4">
                          {(['A', 'B', 'C', 'D'] as const).map((option) => (
                            <FormField
                              key={option}
                              control={form.control}
                              name={`questions.${index}.options.${option}`}
                              render={({ field }) => (
                                <FormItem>
                                  <FormLabel>Option {option}</FormLabel>
                                  <FormControl>
                                    <Input 
                                      {...field} 
                                      placeholder={`Enter option ${option}`} 
                                    />
                                  </FormControl>
                                  <FormMessage />
                                </FormItem>
                              )}
                            />
                          ))}
                        </div>

                        <FormField
                          control={form.control}
                          name={`questions.${index}.correctAnswer`}
                          render={({ field }) => (
                            <FormItem>
                              <FormLabel>Correct Answer</FormLabel>
                              <Select 
                                onValueChange={field.onChange}
                                defaultValue={field.value}
                              >
                                <FormControl>
                                  <SelectTrigger>
                                    <SelectValue placeholder="Select correct answer" />
                                  </SelectTrigger>
                                </FormControl>
                                <SelectContent>
                                  <SelectItem value="option_a">Option A</SelectItem>
                                  <SelectItem value="option_b">Option B</SelectItem>
                                  <SelectItem value="option_c">Option C</SelectItem>
                                  <SelectItem value="option_d">Option D</SelectItem>
                                </SelectContent>
                              </Select>
                              <FormMessage />
                            </FormItem>
                          )}
                        />

                        <FormField
                          control={form.control}
                          name={`questions.${index}.explanation`}
                          render={({ field }) => (
                            <FormItem>
                              <FormLabel>Explanation</FormLabel>
                              <FormControl>
                                <Textarea 
                                  {...field} 
                                  placeholder="Enter explanation"
                                  className="resize-y" 
                                />
                              </FormControl>
                              <FormMessage />
                            </FormItem>
                          )}
                        />
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
            </form>
          </Form>
        );
      
      case 3:
        // ... (keep the existing Step 3 implementation)
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