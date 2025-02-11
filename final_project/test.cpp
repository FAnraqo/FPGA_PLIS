#include <iostream>
#include <fstream>
#include <bitset>
#include <cstdlib> // For rand() and srand()
#include <ctime>   // For time()

// Функция для вывода битовой последовательности файла
void printFileBits(const std::string& filename) {
  std::ifstream file(filename, std::ios::binary);
  if (!file.is_open()) {
    std::cerr << "Error opening file for reading bits: " << filename << std::endl;
    return;
  }

  char byte;
  while (file.get(byte)) { // Читаем по одному байту
    // Преобразуем байт в битовую последовательность (8 бит)
    std::bitset<8> bits(byte);
    if (bits == std::bitset<8>(10))
      std::cout << "\n\n";
    else
      std::cout << bits << " "; // Выводим 8 бит с пробелом
  }

  file.close();
  std::cout << "\n\n";
}

int main() {
  srand(time(0)); // Инициализация генератора случайных чисел

  int mode;
  std::cout << "Mode menu:\n";
  std::cout << "1-Transform input file\n";
  std::cout << "2-Add errors to the text\n";
  std::cout << "3-Exit\n";
  std::cout << "Enter the mode you want: ";
  std::cin >> mode;

  while (mode != 3) {
    switch (mode) {
      case 1: {
        // Имя исходного файла
        std::string inputFilename = "input.txt";
        // Имя выходного файла
        std::string outputFilename = "output.txt";

        // Открываем исходный файл для чтения
        std::ifstream inputFile(inputFilename, std::ios::binary);
        if (!inputFile.is_open()) {
          std::cerr << "Error opening input file: " << inputFilename << std::endl;
          std::cerr << "Make sure the file exists and is in the correct directory." << std::endl;
          return 1;
        }

        // Открываем выходной файл для записи
        std::ofstream outputFile(outputFilename, std::ios::binary);
        if (!outputFile.is_open()) {
          std::cerr << "Error creating output file: " << outputFilename << std::endl;
          inputFile.close();
          return 1;
        }

        // Чтение и запись данных
        char byte;
        while (inputFile.get(byte)) { // Читаем по одному байту из исходного файла
          outputFile.put(byte); // Записываем байт в выходной файл
          outputFile.put('\0'); // Добавляем пустой байт после каждого байта данных
        }

        // Закрываем файлы
        inputFile.close();
        outputFile.close();

        std::cout << "\n\nData successfully written to the output file with null bytes." << std::endl;

        // Выводим битовую последовательность выходного файла
        std::cout << "Bit sequence of the output file:" << std::endl;
        printFileBits(outputFilename);

        break;
      }

      case 2: {
        std::string inputFilename = "input_after_coder.txt";
        std::string outputFilename = "output_with_errors.txt";

        std::ifstream inputFile(inputFilename, std::ios::binary);
        if (!inputFile.is_open()) {
          std::cerr << "Error opening input file: " << inputFilename << std::endl;
          std::cerr << "Make sure the file exists and is in the correct directory." << std::endl;
          return 1;
        }

        std::ofstream outputFile(outputFilename, std::ios::binary);
        if (!outputFile.is_open()) {
          std::cerr << "Error creating output file: " << outputFilename << std::endl;
          inputFile.close();
          return 1;
        }

        std::cout << "Bit sequence of the file Input:" << std::endl;
        printFileBits(inputFilename);

        char byte;
        while (inputFile.get(byte)) { 
          int bitToFlip = rand() % 7 + 1;
          byte ^= (1 << (bitToFlip)); 
          byte ^= (1 << 6); 
          outputFile.put(byte); 
        }

        

        outputFile.close();

        std::cout << "\n\nErrors successfully added to the file." << std::endl;

        
        std::cout << "Bit sequence of the file with errors:" << std::endl;
        printFileBits(outputFilename);

        break;
      }

      case 3:
        break;

      default: {
        std::cout << "Error in mode selection\n\n";
        break;
      }
    }

    if (mode == 3)
      break;

    std::cout << "Mode menu:\n";
    std::cout << "1-Transform input file\n";
    std::cout << "2-Add errors to the text\n";
    std::cout << "3-Exit\n";
    std::cout << "Enter the mode you want: ";
    std::cin >> mode;
  }

  return 0;
}