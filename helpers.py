from langchain.schema import Document
from langchain_community.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from sentence_transformers import SentenceTransformer
import base64
import time
import faiss
from typing import List

def preprocess_chunk(chunk: Document) -> Document:
    if isinstance(chunk, Document):  
        chunk.page_content = chunk.page_content.lower()  
    else:
        raise ValueError("Expected a Document object, but got something else.")
    return chunk


def preprocess(pdf_path: str, query: str = "What is the document about?") -> List[str]:
    # Load and extract text from PDF
    loader = PyPDFLoader(pdf_path)
    documents = loader.load()

    # Initialize a text splitter
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=200, 
        chunk_overlap=50
    )

    # Split the document into smaller chunks
    chunks = text_splitter.split_documents(documents)

    # Preprocess chunks
    processed_chunks = [preprocess_chunk(chunk) for chunk in chunks]
        
    return processed_chunks
    
    # # Generate embeddings using SentenceTransformer
    # model = SentenceTransformer("all-MiniLM-L6-v2")
    # texts = [chunk.page_content for chunk in processed_chunks]
    # embeddings = model.encode(texts)

    # # Create FAISS index and add embeddings
    # index = faiss.IndexFlatL2(embeddings.shape[1])
    # index.add(embeddings)

    # # Perform a similarity search with the query
    # query_embedding = model.encode([query])
    # distances, indices = index.search(query_embedding, k=5) 


    # Return the top retrieved chunks
    # retrieved_chunks = [texts[i] for i in indices[0]]
    
    # print("retrieved_chunks: ", retrieved_chunks)
    # return retrieved_chunks


# def extract_text_from_pdf(pdf_content: bytes) -> str:
#     """Extract text from PDF content"""
#     reader = PdfReader(io.BytesIO(pdf_content))
#     text = ""
#     for page in reader.pages:
#         text += page.extract_text() if page.extract_text() else ''
#     return text


# def split_text_into_chunks(text: str, min_chunk_length: int = 200) -> List[str]:
#     """
#     Split text into meaningful chunks, filtering out small chunks
#     """
#     # Split by paragraphs
#     chunks = [chunk.strip() for chunk in text.split('\n\n') if chunk.strip()]
    
#     # Filter out chunks that are too small and might not contain enough information
#     valid_chunks = [chunk for chunk in chunks if len(chunk) >= min_chunk_length]
    
#     return valid_chunks


def save_to_tmp(file_name, file_extension, content) -> str:
    timestamp = int(time.time() * 1000)
    filename = f"{file_name}_{timestamp}{file_extension}"
    
    with open(f"tmp/{filename}", "wb") as f:
        f.write(content)
    
    return filename

async def encode_file_to_base64(file_content: bytes) -> str:
    """Convert file content to base64 string"""
    return base64.b64encode(file_content).decode('utf-8')