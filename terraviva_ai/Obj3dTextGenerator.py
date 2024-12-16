from pathlib import Path
import base64
from groq import AsyncGroq

import logging
logger = logging.getLogger(__name__)

class Obj3dTextGenerator:
    def __init__(self, model_name: str = "llama-3.2-11b-vision-preview", temperature: float = 0.7):
        self.client = AsyncGroq()
        self.model_name = model_name
        self.temperature = temperature

    def set_model(self, model_name: str):
        self.model_name = model_name
        
    def _encode_image(self, file_path: str) -> str:
        try:
            with open(file_path, 'rb') as image_file:
                encoded_string = base64.b64encode(image_file.read()).decode('utf-8')

                file_extension = Path(file_path).suffix.lower()

                mime_types = {
                    '.png': 'image/png',
                    '.jpg': 'image/jpeg',
                    '.jpeg': 'image/jpeg',
                    '.gif': 'image/gif',
                    '.webp': 'image/webp'
                }
                mime_type = mime_types.get(file_extension, 'image/jpeg')
                return f"data:{mime_type};base64,{encoded_string}"
        except Exception as e:
            raise Exception(f"Failed to encode image: {str(e)}")

    async def describe_object(self, file_path: str) -> str:
        try:
            # Convert the local file to a base64 data URL
            image_data_url = self._encode_image(file_path)
            
            prompt = """
                You are an expert scientific visual descriptor. Your task is to describe objects in images with a precise focus on their scientific characteristics, avoiding any commentary on colors, shapes, or the background unless scientifically relevant.
                Provide detailed, domain-specific descriptions, incorporating terminology and knowledge from fields such as anatomy, geology, chemistry, or other applicable sciences.
                Avoid using phrases like 'The image shows', 'This is', or 'I can see'. Instead, start directly with the object's name and scientifically relevant features.
                Do not describe non-essential visual elements like general colors or aesthetic details. Instead, emphasize structural, compositional, or functional attributes that would be important to a scientist or researcher.
                
                Format: [Object scientific/technical name] characterized by [specific properties, functions, or scientific details]. 
                Maximum length: 1024 characters or less.
            """
            logger.info("model_name: ", self.model_name)
            
            completion = await self.client.chat.completions.create(
                model=self.model_name,
                messages=[
                    {
                        "role": "user",
                        "content": [
                            {
                                "type": "text",
                                "text": prompt
                            },
                            {
                                "type": "image_url",
                                "image_url": {
                                    "url": image_data_url
                                }
                            }
                        ]
                    }
                ],
                temperature=self.temperature,
                max_tokens=1024,
                top_p=1,
                stream=False,
                stop=None
            )
            
            return completion.choices[0].message.content
            
        except Exception as e:
            raise Exception(f"Failed to generate description: {str(e)}")

    async def close(self):
        """Clean up resources."""
        await self.client.close()