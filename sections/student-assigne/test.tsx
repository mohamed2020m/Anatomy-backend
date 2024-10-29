import React from 'react';
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
} from "@/components/ui/command";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Check, ChevronsUpDown, Plus, X } from "lucide-react";

const StudentCategoryAssignment = () => {
  // Sample data - replace with your actual data
  const [students] = React.useState([
    { id: 1, name: "John Doe", email: "john@university.edu", categories: [] },
    { id: 2, name: "Jane Smith", email: "jane@university.edu", categories: [] },
    { id: 3, name: "Mike Johnson", email: "mike@university.edu", categories: [] },
  ]);

  const [categories] = React.useState([
    { id: 1, name: "Honors Student" },
    { id: 2, name: "Student Athlete" },
    { id: 3, name: "International Student" },
    { id: 4, name: "Research Assistant" },
    { id: 5, name: "Teaching Assistant" },
    { id: 6, name: "Scholarship Recipient" },
    { id: 7, name: "Graduate Student" },
    { id: 8, name: "Exchange Student" },
  ]);

  const [selectedStudent, setSelectedStudent] = React.useState(null);
  const [open, setOpen] = React.useState(false);
  const [categoryOpen, setCategoryOpen] = React.useState(false);
  
  const addCategory = (category) => {
    if (selectedStudent) {
      const updatedStudents = students.map(student => {
        if (student.id === selectedStudent.id) {
          const existingCategories = student.categories || [];
          if (!existingCategories.find(c => c.id === category.id)) {
            return {
              ...student,
              categories: [...existingCategories, category]
            };
          }
        }
        return student;
      });
      const updatedStudent = updatedStudents.find(s => s.id === selectedStudent.id);
      setSelectedStudent(updatedStudent);
    }
  };

  const removeCategory = (categoryId) => {
    if (selectedStudent) {
      const updatedStudents = students.map(student => {
        if (student.id === selectedStudent.id) {
          return {
            ...student,
            categories: (student.categories || []).filter(c => c.id !== categoryId)
          };
        }
        return student;
      });
      const updatedStudent = updatedStudents.find(s => s.id === selectedStudent.id);
      setSelectedStudent(updatedStudent);
    }
  };

  return (
    <div className="container mx-auto p-6 max-w-4xl">
      <Card>
        <CardHeader>
          <CardTitle>Student Category Assignment</CardTitle>
          <CardDescription>
            Select a student and assign relevant categories
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="flex flex-col gap-6">
            {/* Student Selection */}
            <div className="flex flex-col gap-2">
              <label className="text-sm font-medium">Select Student</label>
              <Popover open={open} onOpenChange={setOpen}>
                <PopoverTrigger asChild>
                  <Button
                    variant="outline"
                    role="combobox"
                    aria-expanded={open}
                    className="w-full justify-between"
                  >
                    {selectedStudent ? selectedStudent.name : "Select student..."}
                    <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                  </Button>
                </PopoverTrigger>
                <PopoverContent className="w-full p-0">
                  <Command>
                    <CommandInput placeholder="Search students..." />
                    <CommandEmpty>No student found.</CommandEmpty>
                    <CommandGroup>
                      <ScrollArea className="h-64">
                        {students.map((student) => (
                          <CommandItem
                            key={student.id}
                            onSelect={() => {
                              setSelectedStudent(student);
                              setOpen(false);
                            }}
                            className="cursor-pointer"
                          >
                            <Check
                              className={`mr-2 h-4 w-4 ${
                                selectedStudent?.id === student.id
                                  ? "opacity-100"
                                  : "opacity-0"
                              }`}
                            />
                            <div className="flex flex-col">
                              <span>{student.name}</span>
                              <span className="text-sm text-gray-500">
                                {student.email}
                              </span>
                            </div>
                          </CommandItem>
                        ))}
                      </ScrollArea>
                    </CommandGroup>
                  </Command>
                </PopoverContent>
              </Popover>
            </div>

            {/* Category Assignment */}
            {selectedStudent && (
              <div className="flex flex-col gap-4">
                <div className="flex items-center justify-between">
                  <label className="text-sm font-medium">Assigned Categories</label>
                  <Popover open={categoryOpen} onOpenChange={setCategoryOpen}>
                    <PopoverTrigger asChild>
                      <Button variant="outline" size="sm">
                        <Plus className="h-4 w-4 mr-2" />
                        Add Category
                      </Button>
                    </PopoverTrigger>
                    <PopoverContent className="w-64 p-0">
                      <Command>
                        <CommandInput placeholder="Search categories..." />
                        <CommandEmpty>No category found.</CommandEmpty>
                        <CommandGroup>
                          <ScrollArea className="h-48">
                            {categories.map((category) => (
                              <CommandItem
                                key={category.id}
                                onSelect={() => {
                                  addCategory(category);
                                  setCategoryOpen(false);
                                }}
                                className="cursor-pointer"
                              >
                                {category.name}
                              </CommandItem>
                            ))}
                          </ScrollArea>
                        </CommandGroup>
                      </Command>
                    </PopoverContent>
                  </Popover>
                </div>
                
                <div className="flex flex-wrap gap-2">
                  {selectedStudent.categories?.length > 0 ? (
                    selectedStudent.categories.map((category) => (
                      <Badge
                        key={category.id}
                        variant="secondary"
                        className="flex items-center gap-1"
                      >
                        {category.name}
                        <X
                          className="h-3 w-3 cursor-pointer"
                          onClick={() => removeCategory(category.id)}
                        />
                      </Badge>
                    ))
                  ) : (
                    <p className="text-sm text-gray-500">
                      No categories assigned yet
                    </p>
                  )}
                </div>
              </div>
            )}
          </div>
        </CardContent>
      </Card>
    </div>
  );
};

export default StudentCategoryAssignment;