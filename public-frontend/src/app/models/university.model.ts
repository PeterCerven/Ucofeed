export interface University {
  id: number;
  name: string;
  description: string;
  imageUrl?: string;  // Optional, can be null/undefined
  rating: number;     // 0-10
}
