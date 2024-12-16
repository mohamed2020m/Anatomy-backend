import { NextResponse } from 'next/server';
import fs from 'fs';
import path from 'path';

// Définir une fonction pour gérer les requêtes POST (Téléchargement et stockage temporaire)
export async function POST(req: Request) {
  try {
    const { glbUrl } = await req.json();

    if (!glbUrl) {
      return NextResponse.json(
        { error: "L'URL du fichier .glb est requise" },
        { status: 400 }
      );
    }

    const response = await fetch(glbUrl);
    if (!response.ok) {
      return NextResponse.json(
        { error: "Impossible de télécharger le fichier à partir de l'URL fournie" },
        { status: 400 }
      );
    }

    const buffer = await response.arrayBuffer();

    const tempDir = path.join(process.cwd(), 'public', 'temp');
    const fileName = `model_${Date.now()}.glb`;
    const filePath = path.join(tempDir, fileName);

    if (!fs.existsSync(tempDir)) {
      fs.mkdirSync(tempDir, { recursive: true });
    }

    fs.writeFileSync(filePath, Buffer.from(buffer));

    const fileUrl = `/temp/${fileName}`;
    return NextResponse.json({ fileUrl });
  } catch (error) {
    console.error('Erreur:', error);
    return NextResponse.json(
      { error: 'Erreur lors du traitement de la requête' },
      { status: 500 }
    );
  }
}

// Définir une fonction pour gérer les requêtes DELETE (Suppression d'un fichier temporaire)
export async function DELETE(req: Request) {
  try {
    // Extraire le nom du fichier depuis les paramètres de la requête (ou son URL)
    const { searchParams } = new URL(req.url);
    const fileName = searchParams.get('fileName');

    if (!fileName) {
      return NextResponse.json(
        { error: "Le nom du fichier est requis pour la suppression" },
        { status: 400 }
      );
    }

    const tempDir = path.join(process.cwd(), 'public', 'temp');
    const filePath = path.join(tempDir, fileName);

    if (!fs.existsSync(filePath)) {
      return NextResponse.json(
        { error: "Le fichier n'existe pas ou a déjà été supprimé" },
        { status: 404 }
      );
    }

    // Supprimer le fichier
    fs.unlinkSync(filePath);

    return NextResponse.json({ message: "Fichier supprimé avec succès" });
  } catch (error) {
    console.error('Erreur lors de la suppression du fichier:', error);
    return NextResponse.json(
      { error: 'Erreur lors de la suppression du fichier' },
      { status: 500 }
    );
  }
}



export async function GET(req: Request) {
  try {
    // Extraire le nom du fichier depuis les paramètres de la requête
    const { searchParams } = new URL(req.url);
    const fileName = searchParams.get('fileName');

    if (!fileName) {
      return NextResponse.json(
        { error: "Le nom du fichier est requis" },
        { status: 400 }
      );
    }

    const tempDir = path.join(process.cwd(), 'public', 'temp');
    const filePath = path.join(tempDir, fileName);

    if (!fs.existsSync(filePath)) {
      return NextResponse.json(
        { error: "Le fichier demandé n'existe pas" },
        { status: 404 }
      );
    }

    const fileStats = fs.statSync(filePath);

    // Lire le contenu du fichier
    const fileBuffer = fs.readFileSync(filePath);
    const mimeType = 'model/gltf-binary'; // Type MIME pour les fichiers .glb

    return new Response(fileBuffer, {
      headers: {
        'Content-Type': mimeType,
        'Content-Disposition': `attachment; filename="${fileName}"`,
        'Content-Length': fileStats.size.toString(),
      },
    });
  } catch (error) {
    console.error('Erreur lors de la récupération du fichier:', error);
    return NextResponse.json(
      { error: 'Erreur lors de la récupération du fichier' },
      { status: 500 }
    );
  }
}

