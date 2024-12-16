import { Loader2 } from 'lucide-react'

export function BlurPageLoader() {
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-background/80 backdrop-blur-sm">
      <Loader2 className="h-8 w-8 animate-spin text-primary" />
    </div>
  )
}

