import os
from fastapi import FastAPI, Form, UploadFile, File, HTTPException
from typing import List
import Obj3dTextGenerator
from QuizGeneratorPipeline import QuizGenerator, Question
from helpers import extract_text_from_pdf, save_to_tmp, split_text_into_chunks
from fastapi import FastAPI, UploadFile, File, HTTPException
from pathlib import Path
import logging
from fastapi_utils.tasks import repeat_every
import shutil

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

TMP_PATH = r"C:\Users\HP\Documents\Anatomy_Rag\tmp"

app = FastAPI()
quiz_generator = QuizGenerator()
obj3d_text_generator = Obj3dTextGenerator()

@app.on_event("startup")
@repeat_every(seconds=500) 
def cleanup_tmp_folder_task() -> None:
    tmp_folder = Path("tmp")
    if tmp_folder.exists() and tmp_folder.is_dir():
        shutil.rmtree(tmp_folder)
        logger.info("Temporary folder cleaned up.")   
           
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


@app.post("/object_3d-to-text")
async def obj3d_to_text(
    obj: UploadFile = File(...)
):
    try:
        # Read file content
        content = await obj.read()
        
        filename, file_extension = os.path.splitext(obj.filename)
        
        # logger.info(f"filename: {filename}")
        # logger.info(f"file_extension: {file_extension}")
        
        # Encode file to base64
        # base64_image = await encode_file_to_base64(content)
        
        # recreate tmp folder if it does not exist
        os.makedirs("tmp", exist_ok=True)
        
        # save the file to tmp folder
        file_name = save_to_tmp(filename, file_extension, content)
        logger.info(f"File saved to tmp folder: {file_name}")
        
        # Concatenate file_name and tmp_path with Path
        file_path = Path(TMP_PATH) / file_name
        
        # get description
        description = await obj3d_text_generator.describe_object(file_path)
        
        # Return the response with the file path and description
        return {
            "path": str(file_path),
            "description": description
        }
        
        # # Initialize Groq LLM
        # llm = ChatGroq(
        #     model="llama-3.2-11b-vision-preview", 
        #     temperature=0.7,
        #     max_tokens=None,
        #     timeout=None,
        #     max_retries=1,
        # )

        # # System prompt
        # system_prompt = """Act as a professional anatomist and provide a detailed, analytical description 
        # of the 3D anatomy object. Focus strictly on structural and functional aspects, 
        # identifying the type and category of the anatomical part represented, including 
        # its species origin (e.g., human, animal) and relevant substructures or regions. 
        # Explain the biological roles and notable features of each component within the object, 
        # such as specific brain regions or anatomical systems. Avoid any descriptions related 
        # to surface details, texture, or color."""
        
        # tmp_path = r"C:\Users\HP\Documents\Anatomy_Rag\tmp"
        
        # # Concatenate file_name and tmp_path with Path
        # file_path = Path(tmp_path) / file_name
        
        # # Create messages with the image
        # messages = [
        #     {
        #         "role": "user",
        #         "content": system_prompt,
        #         # "images": [f"data:image/jpeg;base64,{base64_image}"]
        #         "images": [fr"{file_path}"]
        #     }
        # ]
        
        # # # Get response from LLM
        # response = await llm.ainvoke(messages)
        
        # # Extract and return the description
        # return {
        #     "path": file_path,
        #     "description": response
        # }

    except Exception as e:
        raise HTTPException(
            status_code=400,
            detail=f"Error processing 3D object: {str(e)}"
        )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)
    
    
    

