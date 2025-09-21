import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { UniversityData } from '@models/csv-uni-data.model';
import { HttpClient } from '@angular/common/http';
import { environment } from '@env/environment.production';


@Injectable({
  providedIn: 'root',
})
export class DataService {
  private readonly apiUrl = `${environment.apiUrl}/private`;
  private readonly http = inject(HttpClient);

  /**
   * Parse file using backend service (preview without saving)
   */
  parseFile(file: File): Observable<UniversityData[]> {
    const formData = new FormData();
    formData.append('file', file);
    return this.http.post<UniversityData[]>(`${this.apiUrl}/parse-file`, formData);
  }

  /**
   * Save parsed data to backend
   */
  saveData(data: UniversityData[]): Observable<string> {
    return this.http.post<string>(`${this.apiUrl}/upload-data`, data, {
      responseType: 'text' as 'json'
    });
  }

  showData() {
    return this.http.get<UniversityData[]>(`${this.apiUrl}/data`);
  }
}
