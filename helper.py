from PyPDF2 import PdfReader
from typing import List
import io

def extract_text_from_pdf(pdf_content: bytes) -> str:
    """Extract text from PDF content"""
    reader = PdfReader(io.BytesIO(pdf_content))
    text = ""
    for page in reader.pages:
        text += page.extract_text() if page.extract_text() else ''
    return text

def split_text_into_chunks(text: str, min_chunk_length: int = 200) -> List[str]:
    """
    Split text into meaningful chunks, filtering out small chunks
    """
    # Split by paragraphs
    chunks = [chunk.strip() for chunk in text.split('\n\n') if chunk.strip()]
    
    # Filter out chunks that are too small and might not contain enough information
    valid_chunks = [chunk for chunk in chunks if len(chunk) >= min_chunk_length]
    
    return valid_chunks
