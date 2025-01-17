

const MESHY_API_TOKEN = process.env.NEXT_PUBLIC_MESHY_API_TOKEN;
const MESHY_API_URL = process.env.NEXT_PUBLIC_MESHY_API_URL;

const API_URL = `${process.env.NEXT_PUBLIC_BACKEND_API}/api/v1`;

export const uploadFile = async (
  file: File,
  token: string,
  type: 'image' | 'objects'
) => {
  try {
    const formData = new FormData();
    formData.append('file', file);

    const response = await fetch(`${API_URL}/files/upload`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${token}`
      },
      body: formData
    });

    if (!response.ok) {
      throw new Error(`Échec de l'upload du fichier ${type}`);
    }

    const data = await response.json();
    return data.path;
  } catch (error) {
    console.error(`Erreur lors de l'upload du fichier ${type}:`, error);
    throw error;
  }
};

export const createThreeDObject = async (data, token: string) => {
  try {
    const response = await fetch(`${API_URL}/threeDObjects`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(data)
    });

    if (!response.ok) {
      throw new Error("Échec de la création de l'objet 3D");
    }

    return await response.json();
  } catch (error) {
    console.error("Erreur lors de la création de l'objet 3D:", error);
    throw error;
  }
};

export const pollModelStatus = async (resultId: string) => {
  const maxAttempts = 40;
  const pollInterval = 7000;

  for (let attempt = 0; attempt < maxAttempts; attempt++) {
    try {
      const response = await fetch(`${MESHY_API_URL}/image-to-3d/${resultId}`, {
        headers: {
          Authorization: `Bearer ${MESHY_API_TOKEN}`,
          Accept: 'application/json'
        }
      });

      if (!response.ok) {
        throw new Error(`Erreur HTTP: ${response.status}`);
      }

      const data = await response.json();

      if (data.status?.toLowerCase() === 'succeeded') {
        return data.model_url;
      }
      if (data.status?.toLowerCase() === 'failed') {
        throw new Error('La génération du modèle 3D a échoué');
      }

      await new Promise((resolve) => setTimeout(resolve, pollInterval));
    } catch (error) {
      console.error('Erreur lors du polling:', error);
      throw error;
    }
  }

  throw new Error("Délai d'attente dépassé");
};

export const storeModelTemporarily = async (modelUrl) => {
  try {
    const response = await fetch(`${process.env.NEXT_PUBLIC_NEXTAUTH_URL}/api/filestorage`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ glbUrl: modelUrl })
    });

    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(
        errorData.error || 'Échec du stockage temporaire du modèle'
      );
    }

    const data = await response.json();
    console.log('Response from filestorage:', data);
    return data.fileUrl;
  } catch (error) {
    console.error('Erreur lors du stockage:', error);
    throw error;
  }
};

export const storeImageTemporarily = async (imageUrl) => {
  try {
    const response = await fetch(`${process.env.NEXT_PUBLIC_NEXTAUTH_URL}/api/imagestorage`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ imageUrl: imageUrl })
    });

    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(
        errorData.error || 'Échec du stockage temporaire de l image'
      );
    }

    const data = await response.json();
    console.log('Response from imagestorage:', data);
    return data.fileUrl;
  } catch (error) {
    console.error('Erreur lors du stockage:', error);
    throw error;
  }
};

export async function fetchTempImage(imageName: string): Promise<File> {
  try {
    const response = await fetch(
      `${process.env.NEXT_PUBLIC_NEXTAUTH_URL}/api/imagestorage?fileName=${imageName}`
    );

    if (!response.ok) {
      const errorData = await response.json();
      console.error(
        'Erreur lors de la récupération du fichier:',
        errorData.error
      );
    }

    const imageBlob = await response.blob(); 
    const image = new File([imageBlob], imageName, {
      type: 'model/gltf-binary'
    }); 
    return image;
  } catch (error) {
    console.error('Erreur de requête:', error);
  }
}

export async function fetchTempGlb(fileName: string): Promise<File> {
  try {
    const response = await fetch(
      `${process.env.NEXTAUTH_URL}/api/filestorage?fileName=${fileName}`
    );

    if (!response.ok) {
      const errorData = await response.json();
      console.error(
        'Erreur lors de la récupération du fichier:',
        errorData.error
      );
    }

    const fileBlob = await response.blob(); // Convertit la réponse en Blob
    const file = new File([fileBlob], fileName, { type: 'model/gltf-binary' }); // Créer un objet File
    return file;
  } catch (error) {
    console.error('Erreur de requête:', error);
  }
}

// Post

export const testPost = async (token) => {
  const postData = {
    name: '3D Model 2',
    description: 'A sample 3D object in subcategory 2',
    image: 'images-benzene.jpg',
    object: 'images-benzene.jpg'
  };

  const apiUrl = `${API_URL}/api/v1/threeDObjects`;

  fetch(apiUrl, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`
    },
    body: JSON.stringify(postData)
  })
    .then((response) => {
      if (!response.ok) {
        throw new Error(`Erreur HTTP : ${response.status}`);
      }
      return response.json();
    })
    .then((data) => {
      console.log("Réponse de l'API :", data);
    })
    .catch((error) => {
      console.error('Erreur lors de la requête :', error);
    });
};


export const uploadFilesSpring = async (
  file: File,
  token: string,
  type: 'image' | 'objects'
) => {
  try {
    const formData = new FormData();
    formData.append('file', file);

    const response = await fetch(`${API_URL}/files/upload`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`
      },
      body: formData
    });

    if (!response.ok) {
      throw new Error(`Échec de l'upload du fichier ${type}`);
    }

    const data = await response.json();
    console.log("reponse de uploadFilesSpring",data)
    if (data.path) {
      return data.path;
    } else {
      throw new Error('Réponse inattendue : le chemin du fichier est manquant');
    }
  } catch (error) {
    console.error(`Erreur lors de l'upload du fichier ${type}:`, error);
    throw error;
  }
};


