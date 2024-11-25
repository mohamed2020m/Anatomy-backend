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
                You are a precise visual descriptor. Provide direct, concise descriptions without any introductory phrases or meta-references to the image itself.
                Provide a direct, concise description of image. 
                Focus only on the essential visual elements and characteristics.
                Do not start with phrases like 'The image shows', 'This is', 'I can see', or 'The image presents'.
                Start directly with the object's description.
                
                Format: [material/color] [object name] with [key characteristics].
                Example: 'Red plastic chair with curved backrest and metal legs.'
            """
            
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


# class Obj3dTextGenerator:
#     def __init__(self, model_name="llama-3.2-11b-vision-preview", temperature=0.7):
#         self.model = ChatGroq(
#             model=model_name,
#             temperature=temperature,
#             max_tokens=None,
#             timeout=None,
#             max_retries=1
#         )
#         # self.system_prompt = """
#         # Act as a professional anatomist and provide a detailed, analytical description 
#         # of the 3D anatomy object. Focus strictly on structural and functional aspects, 
#         # identifying the type and category of the anatomical part represented, including 
#         # its species origin (e.g., human, animal) and relevant substructures or regions. 
#         # Explain the biological roles and notable features of each component within the object, 
#         # such as specific regions or anatomical systems. Avoid any descriptions related 
#         # to surface details, texture, or color.
#         # """
        
#         self.system_prompt = """
#             Describe the following image in 200 words.
#         """
        
#     async def describe_object(self, file_path):
        
#         print("file_path: ", file_path)
#         # Construct the messages with file path
#         messages = [
#             {
#                 "role": "user",
#                 "content": self.system_prompt,
#                 "images": [str(file_path)]
#             }
#         ]
#         # Invoke the model
#         response = await self.model.ainvoke(messages)
#         return response
