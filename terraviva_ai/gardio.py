import openai
import gradio as gr
import random
import faiss
import numpy as np
from PyPDF2 import PdfReader
from dotenv import load_dotenv, find_dotenv
import os
from langchain import LLMChain
from langchain.output_parsers import StructuredOutputParser, ResponseSchema
from langchain.prompts import PromptTemplate
# from langchain.llms import OpenAI
# from langchain.llms import Llama
from langchain_groq import ChatGroq

import json
from sklearn.feature_extraction.text import TfidfVectorizer

from model_validation_mechanism import validate_output

_ = load_dotenv(find_dotenv()) 

# openai.api_key = os.getenv('OPENAI_API_KEY') 
# llm = OpenAI(api_key=openai.api_key) 

llm = ChatGroq(
    model="llama3-8b-8192",
    temperature=0,
    max_tokens=None,
    timeout=None,
    max_retries=2,
)


def extract_text_and_create_chunks(pdf_path, chunk_size=512):
    """
    Extracts text from a PDF and splits it into manageable chunks.
    :param pdf_path: Path to the PDF file.
    :param chunk_size: Number of characters per chunk.
    :return: List of text chunks.
    """
    text = ""
    reader = PdfReader(pdf_path)
    for page in reader.pages:
        text += page.extract_text() if page.extract_text() else ''

    text_chunks = [text[i:i+chunk_size] for i in range(0, len(text), chunk_size)]
    return text_chunks

def index_text_chunks(text_chunks):
    """
    Indexes text chunks using FAISS to facilitate efficient similarity searches.
    :param text_chunks: List of text chunks to index.
    :return: FAISS index and the vectorizer used for feature extraction.
    """
    vectorizer = TfidfVectorizer()
    vectors = vectorizer.fit_transform(text_chunks).toarray()
    index = faiss.IndexFlatL2(vectors.shape[1])
    index.add(vectors)
    return index, vectorizer

def query_chunks(index, vectorizer, query, k=5):
    """
    Queries indexed text chunks to find the most relevant ones based on the query.
    :param index: FAISS index of text chunks.
    :param vectorizer: TF-IDF vectorizer used for text chunks.
    :param query: Query string to search for.
    :param k: Number of results to return.
    :return: Indices of the top k relevant chunks.
    """
    query_vector = vectorizer.transform([query]).toarray()
    distances, indices = index.search(query_vector, k)
    return indices[0]


# def generate_question_and_answer(content):
#     """
#     Generates a multiple-choice question and the correct answer based on the provided content using LangChain.
#     :param content: Text content to base the question and answer on.
#     :return: Generated question, options, correct answer, and explanation.
#     """
#     # Define the response schema
#     response_schemas = [
#         ResponseSchema(name="question", description="The multiple-choice question"),
#         ResponseSchema(name="option_a", description="Option A for the question"),
#         ResponseSchema(name="option_b", description="Option B for the question"),
#         ResponseSchema(name="option_c", description="Option C for the question"),
#         ResponseSchema(name="option_d", description="Option D for the question"),
#         ResponseSchema(name="correct_answer", description="The correct answer for the question which should be one of the multiple-choice question"),
#     ]

#     # Create the output parser
#     output_parser = StructuredOutputParser.from_response_schemas(response_schemas)

#     # Define the prompt template
#     prompt = PromptTemplate(
#         input_variables=["content"],
#         template="""
#             Generate a multiple-choice question based on the following content.
#             Content: {content}
#             {format_instructions}
#         """,
#         partial_variables={"format_instructions": output_parser.get_format_instructions()},
#     ) 
    
#     # Create the LLMChain
#     chain = LLMChain(prompt=prompt, llm=llm)
    
#     # Run the chain with the content
#     result = chain.run(content)
    
#     # Parse the output using the JSON output parser
#     result = output_parser.parse(result)

#     print(result)
    
#     question = result.get("question")
#     correct_answer = result.get("correct_answer")
#     options = ["Option A", "Option B", "Option C", "Option D"]
#     answers = [
#         result.get("option_a"),
#         result.get("option_b"),
#         result.get("option_c"),
#         result.get("option_d")
#     ]
#     pre_answer = ['A) ', 'B) ', 'C) ', 'D)']
#     options_answers = list(zip(options, answers))
#     correct_answer = [option for option, answer in options_answers if answer.strip().lower() == result[correct_answer].strip().lower()]

#     random.shuffle(options)
#     explanation = generate_explanation(question, correct_answer)    
#     question = question + '\n' + " ".join([pre + " " + answer for  pre, answer  in zip(pre_answer, answers)])
#     return question, options, correct_answer, explanation



def generate_question_and_answer(content, max_retries=2):
    """
    Generates a multiple-choice question and the correct answer based on the provided content using LangChain.
    Re-runs the model if output validation fails.
    :param content: Text content to base the question and answer on.
    :param max_retries: Maximum number of retries to get valid output.
    :return: Generated question, options, correct answer, and explanation.
    """
    # Define the response schema
    response_schemas = [
        ResponseSchema(name="question", description="The multiple-choice question"),
        ResponseSchema(name="option_a", description="Option A for the question"),
        ResponseSchema(name="option_b", description="Option B for the question"),
        ResponseSchema(name="option_c", description="Option C for the question"),
        ResponseSchema(name="option_d", description="Option D for the question"),
        ResponseSchema(name="correct_answer", description="The correct answer, provided as the full text of one option."),
    ]

    # Create the output parser
    output_parser = StructuredOutputParser.from_response_schemas(response_schemas)

    # Define the prompt template with clear instructions
    prompt = PromptTemplate(
        input_variables=["content"],
        template="""
            Generate a multiple-choice question based on the following content.
            Content: {content}

            Your response should include:
            - A question
            - Four answer options labeled 'option_a', 'option_b', 'option_c', and 'option_d'
            - The correct answer as the full text of one of the options (e.g., 'Hash Tables')

            {format_instructions}
        """,
        partial_variables={"format_instructions": output_parser.get_format_instructions()},
    )

    # Create the LLMChain
    chain = LLMChain(prompt=prompt, llm=llm)

    # Attempt to generate and validate output, with retries
    for attempt in range(max_retries):
        # Run the model chain with the content
        result = chain.run(content)
        
        # Parse the output using the JSON output parser
        try:
            result = output_parser.parse(result)
        except Exception as e:
            print(f"Error parsing response: {e}")
            continue  # Retry if parsing fails
        
        # result = {
        #     'question': "What is a key component of a blockchain's architecture?", 
        #     'option_a': 'Hash Tables', 
        #     'option_b': 'Distributed Ledger', 
        #     'option_c': 'Public or Private Network', 
        #     'option_d': 'Decentralized Ledger', 
        #     'correct_answer': 'option_b' 
        # }
        print(result)
        
        # Validate the result
        validated_result = validate_output(result)
        
        print(validated_result)
        
        if validated_result:
            question = validated_result.question
            correct_answer = validated_result.correct_answer
            answers = [
                validated_result.option_a,
                validated_result.option_b,
                validated_result.option_c,
                validated_result.option_d,
            ]
            options = ["Option A", "Option B", "Option C", "Option D"]
            pre_answer = ['A) ', 'B) ', 'C) ', 'D)']
            question_text = question + '\n' + " ".join([f"{pre}{answer}" for pre, answer in zip(pre_answer, answers)])

            # Shuffle options randomly
            options_answers = list(zip(options, answers))
            random.shuffle(options_answers)
            options, answers = zip(*options_answers)

            # Generate explanation for correct answer
            explanation = generate_explanation(content, question, correct_answer)
            
            return question_text, options, correct_answer, explanation
        else:
            print(f"Attempt {attempt + 1} failed validation, retrying...")

    print("Failed to generate valid output after multiple attempts.")
    return None, None, None, None


# def generate_explanation(question, correct_answer):
#     """
#     Generates an explanation for the provided question and correct answer.
#     :param question: The question for which to generate an explanation.
#     :param correct_answer: The correct answer to the question.
#     :return: Generated explanation as a string.
#     """
#     prompt = PromptTemplate(
#         input_variables=["question", "correct_answer"],
#         template="Provide an explanation for the following question and answer:\n\nQuestion: {question}\nCorrect Answer: {correct_answer}\n\nExplanation:"
#     )
#     chain = LLMChain(prompt=prompt, llm=llm)
#     return chain.run({"question": question, "correct_answer": correct_answer})


def generate_explanation(content, question, correct_answer):
    """
    Generates an explanation directly based on the content, question, and correct answer, without introductory phrases.
    :param content: The content context for generating the explanation.
    :param question: The question for which to generate an explanation.
    :param correct_answer: The correct answer to the question.
    :return: Directly generated explanation as a string.
    """
    prompt = PromptTemplate(
        input_variables=["content", "question", "correct_answer"],
        template="""
            Use the following content to provide a direct, context-specific explanation of why the correct answer is correct.
            Only provide the explanation without any introductory phrases.
            
            **Content:** {content}
            **Question:** {question}
            **Correct Answer:** {correct_answer}
            
            Explanation:
        """
    )
    chain = LLMChain(prompt=prompt, llm=llm)
    return chain.run({"content": content, "question": question, "correct_answer": correct_answer}).strip()



def generate_question(content):
    """
    Generates a multiple-choice question along with options and the correct answer based on the content.
    :param content: Text content to generate a question from.
    :return: Tuple containing the question, options, correct answer, and explanation.
    """
    question, options, correct_answer, explanation = generate_question_and_answer(content)
    return question, options, correct_answer, explanation

def check_answer(user_answer, correct_answer, explanation, score, count):
    """
    Checks a user's answer against the correct answer, updates the score, and provides feedback.
    
    :param user_answer: The answer provided by the user.
    :param correct_answer: The correct answer to the question.
    :param explanation: Explanation for the correct answer.
    :param score: Current score of the user.
    :param count: Number of questions answered so far.
    :return: Tuple containing the result of the answer check, updated score, and count.
    """
    option_map = {
        "Option A": "option_a",
        "Option B": "option_b",
        "Option C": "option_c",
        "Option D": "option_d"
    }
    
    user_answer_value = option_map.get(user_answer)
    
    if user_answer_value == correct_answer:
        score += 1
        result = "Correct!"
    else:
        result = "Incorrect."
    explanation_text = f"Your answer: {user_answer} -- Correct answer: {correct_answer} -- Explanation: {explanation}"
    count += 1
    return result, explanation_text, score, count

def start_quiz(file, num_questions):
    """
    Starts the quiz by loading the PDF file, extracting text, indexing it, and generating the first question.
    
    :param file: The uploaded PDF file.
    :param num_questions: The total number of questions the user wants to answer.
    :return: Outputs necessary to update the Gradio interface.
    """
    if file is None:
        return "No file uploaded", "", [], "", "", 0, 0, "", "", [], None, None, None, [], num_questions, "Score: 0"
    
    text_chunks = extract_text_and_create_chunks(file.name)
    index, vectorizer = index_text_chunks(text_chunks)    
    chunk_indices = list(range(len(text_chunks)))
    random.shuffle(chunk_indices)
    used_indices = []
    first_index = chunk_indices.pop(0)
    used_indices.append(first_index)
    question, options, correct_answer, explanation = generate_question(text_chunks[first_index])
    print("generate_question done")
    
    return "", question, options, correct_answer, explanation, 0, 0, "", "", options, index, vectorizer, text_chunks, used_indices, num_questions, "Score: 0"

def submit_answer(user_answer, correct_answer, explanation, score, count, index, vectorizer, text_chunks, used_indices, total_questions):
    """
    Processes a user's answer, updates the score, and fetches the next question if available.
    
    :param user_answer: The answer provided by the user.
    :param correct_answer: The correct answer for the current question.
    :param explanation: The explanation for the correct answer.
    :param score: Current user score.
    :param count: Current question count.
    :param index: FAISS index for text chunk retrieval.
    :param vectorizer: Vectorizer used for text encoding.
    :param text_chunks: List of text chunks available for questions.
    :param used_indices: Indices of chunks that have already been used.
    :param total_questions: Total number of questions to be answered.
    :return: Outputs necessary to update the Gradio interface for the next question or to end the quiz.
    """
    result, explanation_text, score, count = check_answer(
        user_answer, correct_answer, explanation, score, count
    )
    score_text = f"Score: {score}/{total_questions}"
    if count >= total_questions:
        grade = f"Your final score is {score} out of {total_questions}."
        return "", "", "", "", result, explanation_text, score, count, grade, [], index, vectorizer, text_chunks, used_indices, total_questions, score_text
    chunk_indices = list(set(range(len(text_chunks))) - set(used_indices))
    if not chunk_indices:
        return "No more questions available", [], "", "", used_indices, None, None, None
    next_index = random.choice(chunk_indices)
    used_indices.append(next_index)
    question, options, correct_answer, explanation = generate_question(text_chunks[next_index])
    return (
        question, options, correct_answer, explanation, result, explanation_text, score, count, "", options, index, vectorizer, text_chunks, used_indices, total_questions, score_text
    )

# Gradio interface
with gr.Blocks() as demo:
    gr.Markdown("### Anatomy / Quiz Generator")

    pdf_file = gr.File(label="Upload the PDF book")
    num_questions = gr.Slider(minimum=1, maximum=50, step=1, value=30, label="Number of Questions")
    start_btn = gr.Button("Start Quiz")

    question_state = gr.State("")
    options_state = gr.State(["Option A", "Option B", "Option C", "Option D"])
    correct_answer_state = gr.State("")
    explanation_state = gr.State("")
    score_state = gr.State(0)
    count_state = gr.State(0)
    total_questions_state = gr.State(30)
    book_content_state = gr.State("")
    index_state = gr.State(None)
    vectorizer_state = gr.State(None)
    text_chunks_state = gr.State(None)
    used_indices_state = gr.State([])

    question_label = gr.Label()
    answer_radio = gr.Radio(choices=[], label="Select an answer")
    submit_btn = gr.Button("Submit")
    result_label = gr.Label()
    explanation_label = gr.Label()
    final_grade_label = gr.Label()
    score_label = gr.Label(label="Score: 0")
    
    # Allow the radio buttons of the answers to be shown from the first question onwards
    start_btn.click(lambda q, o: (gr.update(value=q), gr.update(choices=o)),
                inputs=[question_label, options_state], outputs=[question_label, answer_radio])
    

    start_btn.click(
        start_quiz,
        inputs=[pdf_file, num_questions],
        outputs=[
            book_content_state,
            question_label,
            answer_radio,  
            correct_answer_state,
            explanation_state,
            score_state,
            count_state,
            result_label,
            final_grade_label,
            options_state,  
            index_state,
            vectorizer_state,
            text_chunks_state,
            used_indices_state,
            total_questions_state,
            score_label
        ]
    )
    
    submit_btn.click(
    submit_answer,
    inputs=[
        answer_radio,
        correct_answer_state,
        explanation_state,
        score_state,
        count_state,
        index_state,
        vectorizer_state,
        text_chunks_state,
        used_indices_state,
        total_questions_state
    ],
    outputs=[
        question_label,
        answer_radio,
        correct_answer_state,
        explanation_state,
        result_label,
        explanation_label,
        score_state,
        count_state,
        final_grade_label,
        options_state,  
        index_state,
        vectorizer_state,
        text_chunks_state,
        used_indices_state,
        total_questions_state,
        score_label
    ]
)
    submit_btn.click(lambda q, o: (gr.update(value=q), gr.update(choices=o)), inputs=[question_label, options_state], outputs=[question_label, answer_radio])

    
    demo.launch(share=True, debug=True)
