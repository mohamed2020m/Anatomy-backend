import os
from pathlib import Path
from fastapi import HTTPException
import logging
from langchain_groq import ChatGroq

logger = logging.getLogger(__name__)

class Obj3dTextGenerator:
    def __init__(self, model_name="llama-3.2-11b-vision-preview", temperature=0.7):
        self.model = ChatGroq(
            model=model_name,
            temperature=temperature,
            max_tokens=None,
            timeout=None,
            max_retries=1
        )
        self.system_prompt = """Act as a professional anatomist and provide a detailed, analytical description 
        of the 3D anatomy object. Focus strictly on structural and functional aspects, 
        identifying the type and category of the anatomical part represented, including 
        its species origin (e.g., human, animal) and relevant substructures or regions. 
        Explain the biological roles and notable features of each component within the object, 
        such as specific brain regions or anatomical systems. Avoid any descriptions related 
        to surface details, texture, or color."""
        
    async def describe_object(self, file_path):
        # Construct the messages with file path
        messages = [
            {
                "role": "user",
                "content": self.system_prompt,
                "images": [str(file_path)]
            }
        ]
        # Invoke the model
        response = await self.model.ainvoke(messages)
        return response
