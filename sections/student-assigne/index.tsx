'use client'
import React, { useState, useEffect } from 'react';
import { Button } from '@/components/ui/button';
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import { Checkbox } from '@/components/ui/checkbox';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Input } from "@/components/ui/input";
import { ScrollArea } from '@/components/ui/scroll-area';
import PageContainer from '@/components/layout/page-container';
import { useSession } from 'next-auth/react';
import { toast } from '@/components/ui/use-toast';

// Sample data
// const students = [
//   { id: 1, name: 'John Doe', email: 'john@university.edu' },
//   { id: 2, name: 'Jane Smith', email: 'jane@university.edu' },
//   { id: 3, name: 'Mike Johnson', email: 'mike@university.edu' },
//   { id: 4, name: 'Sarah Williams', email: 'sarah@university.edu' },
//   { id: 5, name: 'David Lee', email: 'david@university.edu' },
// ];

// const categories = [
//   { id: 1, name: 'Honors Student' },
//   { id: 2, name: 'Student Athlete' },
//   { id: 3, name: 'International Student' },
//   { id: 4, name: 'Research Assistant' },
//   { id: 5, name: 'Teaching Assistant' },
//   { id: 6, name: 'Scholarship Recipient' },
//   { id: 7, name: 'Graduate Student' },
//   { id: 8, name: 'Exchange Student' },
// ];

export default function StudentCategoryAssignment() {
  const { data: session } = useSession();
  const [categories, setCategories] = useState<{ id: number; name: string }[]>([]);
  const [students, setStudents] = useState<{ id: number; firstName: string, lastName: string, email: string }[]>([]);
  const [selectedCategory, setSelectedCategory] = useState<{ id: number; name: string } | null>(null);
  const [selectedStudentIds, setSelectedStudentIds] = useState<number[]>([]);
  const [searchTerm, setSearchTerm] = useState("");
  
  
  const filteredStudents = students.filter(student =>
    student.lastName.toLowerCase().includes(searchTerm.toLowerCase()) ||
    student.firstName.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const API_URL = `${process.env.NEXT_PUBLIC_BACKEND_API}/api/v1`

  useEffect(() => {
    const fetchCategories = async () => {
      if (!session) return; // Ensure session is available
      try {
        const response = await fetch(`${API_URL}/professors/${session?.user.id}/sub-categories`, {
          headers: {
            'Authorization': `Bearer ${session?.user.access_token}`,
            'Content-Type': 'application/json'
          },
        });
        const data = await response.json();
        setCategories(data);
      } catch (error) {
        toast({
          title: 'Error',
          description: 'Failed to fetch categories.',
          variant: 'destructive',
        });
      }
    };
    fetchCategories();
  }, []);

  useEffect(() => {
    const fetchStudents = async () => {
      try {
        const response = await fetch(`${API_URL}/students`, {
          headers: {
            'Authorization': `Bearer ${session?.user.access_token}`,
            'Content-Type': 'application/json'
          },
        });
        const data = await response.json();
        setStudents(data);
      } catch (error) {
        toast({
          title: 'Error',
          description: 'Failed to fetch students.',
          variant: 'destructive',
        });
      }
    };
    fetchStudents();
  }, []);

  const handleCategorySelect = (category: { id: number; name: string } | null) => {
    //console.log("Category selected: ", category);
    setSelectedCategory(category);
    setSelectedStudentIds([]); // Clear previous selections when a new category is selected
  };

  const handleStudentSelect = (studentId : number) => {
    setSelectedStudentIds((prevSelected) =>
      prevSelected.includes(studentId)
        ? prevSelected.filter((id) => id !== studentId)
        : [...prevSelected, studentId]
    );
  };

  const handleAssignCategory = async () => {
    if (!selectedCategory || selectedStudentIds.length === 0) {
      toast({
        title: 'Error',
        description: 'Please select both a category and at least one student to assign.',
        variant: 'destructive',
      });
      return;
    }

    // Prepare data in the desired format
    const assignmentData = {
      categoryId: selectedCategory.id,
      studentIds: selectedStudentIds,
    };

    const selectedStudents = students.filter(student => selectedStudentIds.includes(student.id));
    //console.log('Assigned category:', selectedCategory.name);
    //console.log('Selected students:', selectedStudents);
    // alert(`Assigned ${selectedCategory.name} category to ${selectedStudents.length} student(s).`);
    console.log("Data to send to backend : ", assignmentData)

    // Make API call to backend
    try {
      const response = await fetch(`${API_URL}/professors/assign-category`, {
        method: "POST",
        headers: {
          'Authorization': `Bearer ${session?.user.access_token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(assignmentData), // Convert data to JSON string format
      });
  
      if (response.ok) {
        toast({
          title: 'Success',
          description: 'Category assigned successfully.',
          variant: 'success',
        });
      } else {
        const errorData = await response.json();
        toast({
          title: 'Error',
          description: `Error: ${errorData.message}`,
          variant: 'destructive',
        });
      }
    } catch (error) {
      console.error("Error assigning category:", error);
      toast({
        title: 'Error',
        description: 'An error occurred while assigning the category.',
        variant: 'destructive',
      });
    } 

 
    setSelectedCategory(null); // Reset category selection after assignment
    setSelectedStudentIds([]); // Clear selected students
  };

  return (
    <PageContainer scrollable>
    <div className="container mx-auto p-6 max-w-4xl">
      <Card>
        <CardHeader>
          <CardTitle>Student Category Assignment</CardTitle>
          <CardDescription>
            Select a category and assign it to relevant students
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="flex flex-col gap-6">
            {/* Category Selection */}
            <div className="flex flex-col gap-2">
              <label className="text-sm font-medium">Select Category</label>
              <Select onValueChange={(value) => handleCategorySelect(categories.find(cat => cat.name === value) || null)}>
                <SelectTrigger className="w-[280px]">
                  <SelectValue>{selectedCategory?.name || "Select category..."}</SelectValue>
                </SelectTrigger>
                <SelectContent>
                  {categories && categories.map((category) => (
                    <SelectItem key={category.id} value={category.name}>
                      {category.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            
                {/* Student Selection */}
                {selectedCategory && (
                  <div className="flex flex-col gap-4">
                    <label className="text-sm font-medium">Select Students</label>
                    <Input
                      placeholder="Search students..."
                      value={searchTerm}
                      onChange={(e) => setSearchTerm(e.target.value)}
                      className="mb-2"
                    />
                    <ScrollArea className="h-64 overflow-y-auto space-y-2">
                    
                        {filteredStudents.map((student) => (
                          <div key={student.id} className="flex items-center">
                            <Checkbox
                              checked={selectedStudentIds.includes(student.id)}
                              onCheckedChange={() => handleStudentSelect(student.id)}
                            />
                            <span className="ml-2">
                              {student.firstName} {student.lastName} <span className="text-sm text-gray-500">({student.email})</span>
                            </span>
                          </div>
                        ))}
                    </ScrollArea>
                <Button
                  size="lg"
                  onClick={handleAssignCategory}
                  disabled={selectedStudentIds.length === 0}
                >
                  Assign Category
                </Button>
              </div>
            )}
          </div>
        </CardContent>
      </Card>
    </div>
    </PageContainer>
  );
}
