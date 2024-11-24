const MESHY_API_TOKEN = 'msy_oKkPyfAgt72h3PXdhyueB2RUSDIy3MVGwK3O';
const MESHY_API_URL = 'https://api.meshy.ai/v1';

export const uploadFile = async (
  file: File,
  token: string,
  type: 'image' | 'objects'
) => {
  try {
    const formData = new FormData();
    formData.append('file', file);

    const response = await fetch(`http://localhost:8080/api/v1/files/upload`, {
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
    const response = await fetch(`http://localhost:8080/api/v1/threeDObjects`, {
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

export const storeFileTemporarily = async (modelUrl) => {
  try {
    const response = await fetch('http://localhost:3000/api/filestorage', {
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
    const response = await fetch('http://localhost:3000/api/imagestorage', {
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


export async function fetchTempImage(imageName: string): Promise<File > {
  try {
    const response = await fetch(`http://localhost:3000/api/imagestorage?fileName=${imageName}`);

    if (!response.ok) {
      const errorData = await response.json();
      console.error('Erreur lors de la récupération du fichier:', errorData.error);
    }

    const imageBlob = await response.blob(); // Convertit la réponse en Blob
    const image = new File([imageBlob], imageName, { type: 'model/gltf-binary' }); // Créer un objet File
    return image;
  } catch (error) {
    console.error('Erreur de requête:', error);
  }
}

export async function fetchTempGlb(fileName: string): Promise<File> {
  try {
    const response = await fetch(`http://localhost:3000/api/filestorage?fileName=${fileName}`);

    if (!response.ok) {
      const errorData = await response.json();
      console.error('Erreur lors de la récupération du fichier:', errorData.error);
    }

    const fileBlob = await response.blob(); // Convertit la réponse en Blob
    const file = new File([fileBlob], fileName, { type: 'model/gltf-binary' }); // Créer un objet File
    return file;
  } catch (error) {
    console.error('Erreur de requête:', error);

  }
}