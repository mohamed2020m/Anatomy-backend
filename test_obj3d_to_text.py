# llama vesion for Object 3d to Text
from fastapi import FastAPI, UploadFile, File, HTTPException
from langchain_groq import ChatGroq
from langchain.schema import HumanMessage, SystemMessage
import base64
import asyncio

from Obj3dTextGenerator import Obj3dTextGenerator


# def encode_file_to_base64(file_content: bytes) -> str:
#     """Convert file content to base64 string"""
#     return base64.b64encode(file_content).decode('utf-8')

# async def obj3d_to_text():
#     with open("images/brain.jpg", "rb") as f:
#         content = f.read()
        
#     # Encode file to base64
#     base64_image = encode_file_to_base64(content)
    
#     # Initialize Groq LLM
#     llm = ChatGroq(
#         model="llama-3.2-11b-vision-preview", 
#         temperature=0.7,
#         max_tokens=None,
#         timeout=None,
#         max_retries=1,
#     )

#     # System prompt
#     system_prompt = """Act as a professional anatomist and provide a detailed, analytical description 
#     of the 3D anatomy object. Focus strictly on structural and functional aspects, 
#     identifying the type and category of the anatomical part represented, including 
#     its species origin (e.g., human, animal) and relevant substructures or regions. 
#     Explain the biological roles and notable features of each component within the object, 
#     such as specific brain regions or anatomical systems. Avoid any descriptions related 
#     to surface details, texture, or color."""

#     # Create messages with the image
#     messages = [
#         {
#             "role": "user",
#             "content": system_prompt,
#             # "images": [f"data:image/jpeg;base64,{base64_image}"]
#             "images": [fr"C:\Users\HP\Documents\Anatomy_Rag\images\brain.jpg"]
#         }
#     ]
    

#     # Get response from LLM
#     print("Start invoking...")
#     response = await llm.ainvoke(messages)
    
#     print("response: ", response)
    
    
    

async def main():
    generator = Obj3dTextGenerator()
    try:
        description = await generator.describe_object("./images/875875845.png")
        print(description)
    finally:
        await generator.close()


if __name__ == "__main__":
    try:
        # asyncio.run(obj3d_to_text())
        asyncio.run(main())
    except RuntimeError as e:
        if str(e) == "Event loop is closed":
            loop = asyncio.new_event_loop()
            asyncio.set_event_loop(loop)
            # loop.run_until_complete(obj3d_to_text())
            loop.run_until_complete(main())


