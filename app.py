from fastapi import FastAPI, Form, UploadFile, File, HTTPException
from typing import List
from pipeline import QuizGenerator, Question
from helper import extract_text_from_pdf, split_text_into_chunks

app = FastAPI()
quiz_generator = QuizGenerator()

@app.get("/")
async def entry():
    return {"message": "Terraviva Quiz Generator"}

@app.post("/generate-quiz", response_model=List[Question])
async def generate_quiz(
    file: UploadFile = File(...),
    num_questions: int = Form(10)
):
    """Generate quiz questions from PDF content"""
    try:
        # Read PDF file
        content = await file.read()
        
        # Extract text from PDF
        text = extract_text_from_pdf(content)
        
        # Split into chunks
        chunks = split_text_into_chunks(text)
        
        if not chunks:
            raise HTTPException(
                status_code=400,
                detail="Could not extract enough valid content from the PDF"
            )
            
        # Generate questions
        questions = quiz_generator.generate_quiz(chunks, num_questions)
        print(questions)
        
        return questions
        
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)