"use client";

import React from 'react';

// import { Skeleton } from '@/components/ui/skeleton';
// import { Tooltip, TooltipTrigger, TooltipContent, TooltipProvider } from '@/components/ui/tooltip';

// import {
//     AlertDialog,
//     AlertDialogTrigger,
//     AlertDialogContent,
//     AlertDialogHeader,
//     AlertDialogFooter,
//     AlertDialogTitle,
//     AlertDialogDescription,
//     AlertDialogAction,
//     AlertDialogCancel,
// } from '@/components/ui/alert-dialog';


// import {
//     CommandDialog,
//     CommandInput,
//     CommandList,
//     CommandItem,
//     CommandEmpty,
//     CommandGroup,
// } from '@/components/ui/command';

import { useToast } from '@/components/ui/use-toast';
import { ToastAction } from '@/components/ui/toast';


export default function Test() {
    const { toast } = useToast();

    const showToast = () => {
        toast({
            title: 'Success!',
            description: 'Your operation was successful.',
            action: (
                <ToastAction onClick={() => alert('Action clicked!')} altText={''}>
                    Undo
                </ToastAction>
            ),
        });
    };

    return <>
        <button onClick={showToast}>Show Toast</button>
        
        {/* <button>Open Command Palette</button>
        <CommandDialog open={open}>
            <CommandInput placeholder="Type a command..." />
            <CommandList>
                <CommandEmpty>No results found.</CommandEmpty>
                <CommandGroup heading="Actions">
                    <CommandItem>Open File</CommandItem>
                    <CommandItem>Save</CommandItem>
                </CommandGroup>
                <CommandGroup heading="Navigation">
                    <CommandItem>Go to Line</CommandItem>
                    <CommandItem>Search</CommandItem>
                </CommandGroup>
            </CommandList>
        </CommandDialog> */}

        {/* <AlertDialog>
            <AlertDialogTrigger asChild>
                <button className="px-4 py-2 bg-red-500 text-white rounded-md">
                    Delete Account
                </button>
            </AlertDialogTrigger>
            <AlertDialogContent>
                <AlertDialogHeader>
                    <AlertDialogTitle>Are you absolutely sure?</AlertDialogTitle>
                    <AlertDialogDescription>
                        This action cannot be undone. This will permanently delete your account.
                    </AlertDialogDescription>
                </AlertDialogHeader>
                <AlertDialogFooter>
                    <AlertDialogCancel>Cancel</AlertDialogCancel>
                    <AlertDialogAction>Confirm</AlertDialogAction>
                </AlertDialogFooter>
            </AlertDialogContent>
        </AlertDialog> */}

        {/* Tooltip Example */}
        {/* <TooltipProvider>
            <Tooltip>
                <TooltipTrigger asChild>
                    <button className="px-4 py-2 bg-primary text-white rounded-md">
                        Hover me
                    </button>
                </TooltipTrigger>
                <TooltipContent sideOffset={8} className="bg-gray-800 text-white">
                    This is a tooltip with custom content!
                </TooltipContent>
            </Tooltip>
        </TooltipProvider> */}

        {/* Skeleton Example */}
        {/* <div className='p-2'>
            <h1>Test</h1>
            <Skeleton className="h-12 w-1/2" /> 
        </div> */}
    </>;
}
