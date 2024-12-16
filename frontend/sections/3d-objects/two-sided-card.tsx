'use client';

import * as React from 'react';
import { motion } from 'framer-motion';
import { Loader2 } from 'lucide-react';
import ThreeDObjectsForm from './3d-objects-form';
import AiGenerationForm from './ai-generation-form';

const TwoSidedCard = () => {
  const [isAI, setIsAI] = React.useState(false);
  const [isFlipping, setIsFlipping] = React.useState(false);

  const handleFlip = () => {
    setIsFlipping(true);
    setIsAI((prev) => !prev);
    setTimeout(() => setIsFlipping(false), 500);
  };

  return (
    <div className="w-full min-h-screen bg-background text-foreground">
      <div className="relative w-full max-w-4xl mx-auto">
        {/* Card Container */}
        <div
          className={`
            relative w-full aspect-[4/3] rounded-xl 
            transition-all duration-500 ease-in-out
            ${isFlipping ? 'pointer-events-none' : ''}
            bg-card/50 backdrop-blur-sm
          `}
          style={{
            perspective: '1500px',
            transformStyle: 'preserve-3d',
          }}
        >
          {/* Flip Button */}
          <button
            onClick={handleFlip}
            className="absolute right-4 top-4 z-50 bg-button rounded-full shadow-lg hover:bg-button-hover transition-colors"
            disabled={isFlipping}
          >
            {isFlipping ? (
              <Loader2 className="w-6 h-6 animate-spin text-foreground" />
            ) : (
              <svg
                className="w-6 h-6 text-foreground"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
                />
              </svg>
            )}
          </button>

          {/* Front Card */}
          <div
            className={`
              absolute w-full h-full rounded-xl overflow-auto
              transition-all duration-500
              ${isAI ? 'rotate-y-180 pointer-events-none' : 'rotate-y-0'}
              bg-card shadow-xl 
              scrollbar-thin scrollbar-thumb-scrollbar-thumb scrollbar-track-scrollbar-track
            `}
            style={{
              backfaceVisibility: 'hidden',
              transform: isAI ? 'rotateY(180deg)' : 'rotateY(0deg)',
            }}
          >
            <div className="h-full p-4">
              <ThreeDObjectsForm />
            </div>
          </div>

          {/* Back Card */}
          <div
            className={`
              absolute w-full h-full rounded-xl overflow-auto
              transition-all duration-500
              ${isAI ? 'rotate-y-0' : 'rotate-y-180 pointer-events-none'}
              bg-card shadow-xl 
              scrollbar-thin scrollbar-thumb-scrollbar-thumb scrollbar-track-scrollbar-track
            `}
            style={{
              backfaceVisibility: 'hidden',
              transform: isAI ? 'rotateY(0deg)' : 'rotateY(180deg)',
            }}
          >
            <div className="h-full p-4">
              <AiGenerationForm />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default TwoSidedCard;