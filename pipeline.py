from langchain import LLMChain
from langchain.prompts import PromptTemplate
from langchain_groq import ChatGroq
from langchain.output_parsers import StructuredOutputParser, ResponseSchema
from typing import Dict, List
from pydantic import BaseModel
import random

class Question(BaseModel):
    question: str
    options: Dict[str, str]
    correct_answer: str
    explanation: str

class QuizGenerator:
    def __init__(self):
        # Initialize LLM
        self.llm = ChatGroq(
            model="llama3-8b-8192",
            temperature=0.7, 
            max_tokens=None,
            timeout=None,
            max_retries=2,
        )
        
        # Define response schemas
        self.response_schemas = [
            ResponseSchema(name="question", description="The multiple-choice question"),
            ResponseSchema(name="option_a", description="Option A for the question"),
            ResponseSchema(name="option_b", description="Option B for the question"),
            ResponseSchema(name="option_c", description="Option C for the question"),
            ResponseSchema(name="option_d", description="Option D for the question"),
            ResponseSchema(name="correct_answer", description="The correct answer, provided as the full text of one option"),
        ]
        
        self.output_parser = StructuredOutputParser.from_response_schemas(self.response_schemas)
        
        # Updated question prompt to encourage diverse questions
        self.question_prompt = PromptTemplate(
            input_variables=["content", "existing_questions"],
            template="""
                Generate a unique multiple-choice question based on the following content.
                Make sure the question is different from any previously generated questions.
                
                Content: {content}
                Previously generated questions: {existing_questions}

                Your response should include:
                - A question that tests a different aspect or concept from the previous questions
                - Four answer options labeled 'option_a', 'option_b', 'option_c', and 'option_d'
                - The correct answer as the full text of one of the options

                {format_instructions}
            """,
            partial_variables={"format_instructions": self.output_parser.get_format_instructions()},
        )
        
        self.explanation_prompt = PromptTemplate(
            input_variables=["content", "question", "correct_answer"],
            template="""
                Use the following content to explain why this answer is correct:
                Content: {content}
                Question: {question}
                Correct Answer: {correct_answer}
                
                Explanation:
            """
        )

    def generate_question(self, content: str, existing_questions: List[str] = None) -> Question:
        """Generate a single question from content"""
        try:
            # Generate question and options
            question_chain = LLMChain(prompt=self.question_prompt, llm=self.llm)
            result = question_chain.run(
                content=content,
                existing_questions=str(existing_questions) if existing_questions else "[]"
            )
            parsed_result = self.output_parser.parse(result)
            
            # Generate explanation
            explanation_chain = LLMChain(prompt=self.explanation_prompt, llm=self.llm)
            explanation = explanation_chain.run({
                "content": content,
                "question": parsed_result["question"],
                "correct_answer": parsed_result["correct_answer"]
            })
            
            return Question(
                question=parsed_result["question"],
                options={
                    "A": parsed_result["option_a"],
                    "B": parsed_result["option_b"],
                    "C": parsed_result["option_c"],
                    "D": parsed_result["option_d"],
                },
                correct_answer=parsed_result["correct_answer"],
                explanation=explanation.strip()
            )
        except Exception as e:
            raise Exception(f"Failed to generate question: {str(e)}")

    def generate_quiz(self, chunks: List[str], num_questions: int) -> List[Question]:
        """Generate requested number of questions, potentially using chunks multiple times"""
        questions = []
        existing_questions = []
        
        # If we have fewer chunks than requested questions, we'll reuse chunks
        while len(questions) < num_questions:
            # Randomly select a chunk if there are multiple
            chunk = random.choice(chunks) if len(chunks) > 1 else chunks[0]
            
            # Generate a new question from this chunk
            question = self.generate_question(chunk, existing_questions)
            questions.append(question)
            existing_questions.append(question.question)
            
        return questions