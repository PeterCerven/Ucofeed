import { Injectable } from '@angular/core';
import { UniversityExcelData } from '../models/csv-uni-data.model';
import * as XLSX from 'xlsx';

@Injectable({ providedIn: 'root' })
export class FileParseService {

  constructor() {
  }

  parseFile(file: File): Promise<UniversityExcelData[]> {
    const fileExtension = file.name.split('.').pop()?.toLowerCase();
    switch (fileExtension) {
      case 'xlsx':
      case 'xls':
        return this.parseExcelFile(file);
      case 'csv':
        return this.parseCsvFile(file);
      default:
        return Promise.reject(new Error('Unsupported file type'));
    }
  }

  parseExcelFile(file: File): Promise<UniversityExcelData[]> {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = (e: ProgressEvent<FileReader>) => {
        try {
          const binaryString = e.target?.result;
          if (!binaryString) {
            reject(new Error("File content is empty."));
            return;
          }

          const workbook: XLSX.WorkBook = XLSX.read(binaryString, { type: 'binary' });
          const firstSheetName: string = workbook.SheetNames[0];
          const worksheet: XLSX.WorkSheet = workbook.Sheets[firstSheetName];

          const jsonData = XLSX.utils.sheet_to_json<UniversityExcelData>(worksheet);
          const mappedData = this.mapDataFromSlovakToEnglish(jsonData);

          resolve(mappedData);

        } catch (error) {
          reject(error);
        }
      };

      reader.onerror = (error) => {
        reject(error);
      };

      reader.readAsArrayBuffer(file);
    });
  }


  private parseCsvFile(file: File) {
    return Promise.resolve([]);
  }

  private mapDataFromSlovakToEnglish(jsonData: any[]): UniversityExcelData[] {
    return jsonData.map(row => ({
      programName: row['Názov študijného programu'],
      university: row['Vysoká škola'],
      faculty: row['Fakulta'],
      educationLevel: row['Stupeň vzdelania'],
      studyType: row['Metódy štúdia'],
      studyForm: row['Forma štúdia'],
      studyGroupSubjects: row['Skupina študijných odborov'],
    }));

  }
}
