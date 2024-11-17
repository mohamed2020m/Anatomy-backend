import random
from langchain import LLMChain
from langchain.output_parsers import StructuredOutputParser, ResponseSchema
from langchain.prompts import PromptTemplate
from dotenv import load_dotenv, find_dotenv
from langchain_groq import ChatGroq

from model_validation_mechanism import validate_output

_ = load_dotenv(find_dotenv()) 


sample_content = """
    The history of blockchain technology is rooted in cryptography, distributed computing, and the pursuit of secure digital transactions. Here’s a look at how blockchain evolved from a concept into a transformative technology.

    ### 1. **Origins and Foundational Concepts (1970s–1990s)**

    - **1976:** *Cryptographic principles emerge.* Researchers Whitfield Diffie and Martin Hellman introduced the concept of public-key cryptography, a breakthrough in secure digital communications that later influenced blockchain.
    - **1982:** *Decentralized systems proposed.* David Chaum, a cryptographer, proposed a blockchain-like cryptographic protocol to ensure digital security and privacy.
    - **1991:** *The first blockchain-related concept is patented.* Stuart Haber and W. Scott Stornetta described a cryptographically secured chain of blocks as a way to timestamp digital documents and ensure they couldn't be backdated or tampered with. This system forms a fundamental part of modern blockchain.

    ### 2. **The Creation of Bitcoin and Blockchain (2008–2009)**

    - **2008:** *The Bitcoin white paper is published.* An unknown person or group using the pseudonym Satoshi Nakamoto released the white paper titled "Bitcoin: A Peer-to-Peer Electronic Cash System." The paper proposed a decentralized digital currency system built on blockchain technology.
    - **2009:** *The first Bitcoin transaction occurs.* Nakamoto mined the first block, known as the *genesis block*, and embedded a message referencing the financial crisis to mark the moment. This transaction was the first implementation of blockchain technology, where the blockchain served as a public ledger for Bitcoin.

    ### 3. **Expansion Beyond Bitcoin (2013–2015)**

    - **2013:** *Ethereum is conceptualized.* Programmer Vitalik Buterin proposed Ethereum as a blockchain-based platform not limited to financial transactions. Buterin’s vision was a decentralized platform that could support smart contracts, self-executing agreements coded directly onto the blockchain.
    - **2015:** *Ethereum is launched.* The Ethereum blockchain went live, introducing "smart contracts" and enabling developers to build decentralized applications (dApps) using blockchain technology. This marked a shift from blockchain as just a ledger for cryptocurrencies to a broader technology for decentralized applications.

    ### 4. **Mainstream Interest and Innovation (2016–2018)**

    - **2016:** *Initial Coin Offerings (ICOs) gain popularity.* Startups began raising funds by issuing new cryptocurrencies on platforms like Ethereum. ICOs allowed companies to raise capital in exchange for tokens but also attracted regulatory scrutiny due to fraud concerns.
    - **2017:** *Bitcoin and blockchain technology reach a wider audience.* Bitcoin’s price surged, drawing attention to blockchain as an emerging technology. Other blockchain projects, such as Litecoin and Ripple, also gained traction.
    - **2018:** *Global interest and regulatory attention increase.* Countries worldwide began considering how to regulate blockchain-based assets, and discussions about blockchain’s potential in industries beyond finance gained momentum. The technology’s potential for areas like supply chain, healthcare, and identity verification became widely recognized.

    ### 5. **Adoption in Various Industries (2019–2020)**

    - **2019:** *Enterprise-level applications and DeFi emerge.* Large corporations like IBM, Amazon, and Microsoft began incorporating blockchain technology into their platforms for supply chain management, logistics, and more. Additionally, Decentralized Finance (DeFi) applications gained popularity, using blockchain to create financial products without intermediaries.
    - **2020:** *Central Bank Digital Currencies (CBDCs) and stablecoins gain momentum.* Governments began exploring digital currencies backed by their central banks, recognizing the potential benefits of digital assets. At the same time, stablecoins, which are blockchain-based assets pegged to traditional currencies, grew in popularity as a solution for price stability in the crypto market.

    ### 6. **The Rise of NFTs and Web3 (2021–Present)**

    - **2021:** *NFTs enter the mainstream.* Non-fungible tokens (NFTs), unique digital assets stored on the blockchain, became widely popular for digital art, collectibles, and virtual goods, particularly on platforms like Ethereum.
    - **2022:** *Web3 gains traction.* Web3, a vision of a more decentralized internet using blockchain, became a focal point for the next evolution of the web. It aims to empower users with greater control over their data and interactions online.
    - **2023:** *Blockchain continues to diversify.* Blockchains tailored to specific applications and use cases (e.g., gaming, social media, and finance) have emerged, while layer-2 solutions and cross-chain technologies have evolved to address scalability and interoperability challenges in blockchain networks.

    ### Summary

    Blockchain has transformed from a niche concept in cryptography to a mainstream technology impacting a broad range of industries. Its applications are expanding rapidly, promising more innovation as businesses, governments, and communities explore new possibilities in this decentralized, transparent, and secure digital landscape.
        
"""

llm = ChatGroq(
    model="llama3-8b-8192",
    temperature=0,
    max_tokens=None,
    timeout=None,
    max_retries=2,
)

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


def generate_explanation(question, correct_answer):
    """
    Generates an explanation for the provided question and correct answer.
    :param question: The question for which to generate an explanation.
    :param correct_answer: The correct answer to the question.
    :return: Generated explanation as a string.
    """
    prompt = PromptTemplate(
        input_variables=["question", "correct_answer"],
        template="Provide an explanation for the following question and answer:\n\nQuestion: {question}\nCorrect Answer: {correct_answer}\n\nExplanation:"
    )
    chain = LLMChain(prompt=prompt, llm=llm)
    return chain.run({"question": question, "correct_answer": correct_answer})


def generate_question_and_answer(content):
    result = {
        'question': 'Who proposed a blockchain-like cryptographic protocol to ensure digital security and privacy in 1982?', 
        'option_a': 'Whitfield Diffie and Martin Hellman', 
        'option_b': 'David Chaum', 
        'option_c': 'Stuart Haber and W. Scott Stornetta', 
        'option_d': 'Satoshi Nakamoto', 
        'correct_answer': 'option_b'
    }
    
    validated_result = validate_output(result)
    print("validated_result: ", validated_result)
    
    # question = result.get("question")
    # correct_answer = result.get("correct_answer")
    # options = ["Option A", "Option B", "Option C", "Option D"]
    # answers = [
    #     result.get("option_a"),
    #     result.get("option_b"),
    #     result.get("option_c"),
    #     result.get("option_d")
    # ]
    # pre_answer = ['A) ', 'B) ', 'C) ', 'D)']
    # options_answers = list(zip(options, answers))
    # correct_answer = [option for option, answer in options_answers if answer.strip().lower() == result[correct_answer].strip().lower()]

    # random.shuffle(options)
    # explanation = generate_explanation(question, correct_answer)    
    # question = question + '\n' + " ".join([pre + " " + answer for  pre, answer  in zip(pre_answer, answers)])
    # return question, options, correct_answer, explanation

    
# Inject the mocked chain to replace actual LLMChain behavior
def test_generate_question_and_answer():    

    # generate_question_and_answer(sample_content)
    
    # Run the function with the sample content
    question, options, correct_answer, explanation = generate_question_and_answer(sample_content)
    
    # Display the results for inspection
    print("Generated Question:", question)
    
    print("Options:", options)

    print("Correct Answer:", correct_answer)
    
    print("Explanation:", explanation)

# Call the test function to run it
test_generate_question_and_answer()



