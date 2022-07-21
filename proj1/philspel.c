/*
 * Include the provided hash table library.
 */
#include "hashtable.h"

/*
 * Include the header file.
 */
#include "philspel.h"

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Character utility routines.
 */
#include <ctype.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * This hash table stores the dictionary.
 */
HashTable *dictionary;

/*
 * The MAIN routine.  You can safely print debugging information
 * to standard error (stderr) as shown and it will be ignored in 
 * the grading process.
 */
int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "Specify a dictionary\n");
    return 0;
  }
  /*
   * Allocate a hash table to store the dictionary.
   */
  fprintf(stderr, "Creating hashtable\n");
  dictionary = createHashTable(2255, &stringHash, &stringEquals);

  fprintf(stderr, "Loading dictionary %s\n", argv[1]);
  readDictionary(argv[1]);
  fprintf(stderr, "Dictionary loaded\n");

  fprintf(stderr, "Processing stdin\n");
  processInput();

  /*
   * The MAIN function in C should always return 0 as a way of telling
   * whatever program invoked this that everything went OK.
   */
  return 0;
}

/*
 * This should hash a string to a bucket index.  Void *s can be safely cast
 * to a char * (null terminated string) and is already done for you here 
 * for convenience.
 */
unsigned int stringHash(void *s) {
  char *string = (char *)s;
  const int para = 17;
  // -- TODO --
  unsigned int ret = 0;
  int c;
  while((c = *(string++))) {
    ret += ret * para + c;
  }
  return ret;
}

/*
 * This should return a nonzero value if the two strings are identical 
 * (case sensitive comparison) and 0 otherwise.
 */
int stringEquals(void *s1, void *s2) {
  char *string1 = (char *)s1;
  char *string2 = (char *)s2;
  // -- TODO --
  if(strcmp(string1, string2) == 0) {
    return 1;
  }
  return 0;
}

/*
 * This function should read in every word from the dictionary and
 * store it in the hash table.  You should first open the file specified,
 * then read the words one at a time and insert them into the dictionary.
 * Once the file is read in completely, return.  You will need to allocate
 * (using malloc()) space for each word.  As described in the spec, you
 * can initially assume that no word is longer than 60 characters.  However,
 * for the final 20% of your grade, you cannot assumed that words have a bounded
 * length.  You CANNOT assume that the specified file exists.  If the file does
 * NOT exist, you should print some message to standard error and call exit(1)
 * to cleanly exit the program.
 *
 * Since the format is one word at a time, with new lines in between,
 * you can safely use fscanf() to read in the strings until you want to handle
 * arbitrarily long dictionary chacaters.
 */
void readDictionary(char *dictName) {
  // -- TODO --
  FILE *fp = fopen(dictName, "r");
  if (fp == NULL) {
    fprintf(stderr, "cant find the file.");
    exit(1);
  }
  int size = 60;
  char *word = (char *)malloc(sizeof(char) * size);
  int c,i = 0;

  while ((c = fgetc(fp)) != EOF) {
    if (i == size) {
      size *= 2;
      word = (char *)realloc(word, size);
    }
    if (c == '\n') {
      char *key = (char *)malloc((i + 1) * sizeof(char));
      memcpy(key, word, i);
      key[i] = '\0';
      if(findData(dictionary,key) == NULL) {
        insertData(dictionary, key, key);
      }
      i = 0;
      continue;
    }
    word[i] = c;
    i ++;
  }
  fclose(fp);
  free(word);
}

/*
 * This should process standard input (stdin) and copy it to standard
 * output (stdout) as specified in the spec (e.g., if a standard 
 * dictionary was used and the string "this is a taest of  this-proGram" 
 * was given to stdin, the output to stdout should be 
 * "this is a teast [sic] of  this-proGram").  All words should be checked
 * against the dictionary as they are input, then with all but the first
 * letter converted to lowercase, and finally with all letters converted
 * to lowercase.  Only if all 3 cases are not in the dictionary should it
 * be reported as not found by appending " [sic]" after the error.
 *
 * Since we care about preserving whitespace and pass through all non alphabet
 * characters untouched, scanf() is probably insufficent (since it only considers
 * whitespace as breaking strings), meaning you will probably have
 * to get characters from stdin one at a time.
 *
 * Do note that even under the initial assumption that no word is longer than 60
 * characters, you may still encounter strings of non-alphabetic characters (e.g.,
 * numbers and punctuation) which are longer than 60 characters. Again, for the 
 * final 20% of your grade, you cannot assume words have a bounded length.
 */
void processInput() {
  // -- TODO --
   int size = 60;
  char *str1 = (char *)malloc(sizeof(char) * size);
  char *str2 = (char *)malloc(sizeof(char) * size);
  char *str3 = (char *)malloc(sizeof(char) * size);
  int c, i = 0;
  while((c = fgetc(stdin)) != EOF) {
    if(i == size) {
      size *= 2;
      str1 = (char *)realloc(str1, size);
      str2 = (char *)realloc(str2, size);
      str3 = (char *)realloc(str3, size);
    }
    if(isalpha(c)) {
      // 1. The word itself
      str1[i] = (char) c;
      // 2. The word converted entirely to lowercase letters
      str2[i] = (char) tolower(c);
      // 3. The word with all but the first letter converted to lowercase.
      // if(i == 0) {
      //   str3[i] = (char) toupper(c);
      // } else {
      //   str3[i] = (char) tolower(c);
      // }
      str3[i] = (i == 0) ? c : (char)tolower(c);
      i += 1;    
    } else {
     if(isalpha(str1[0])) {
       str1[i] = '\0';
       str2[i] = '\0';
       str3[i] = '\0';
       if (findData(dictionary, str1) == NULL && findData(dictionary, str2) == NULL && findData(dictionary, str3) == NULL) {
         fprintf(stdout, "%s [sic]%c", str1, c);
       } else {
         fprintf(stdout, "%s%c", str1, c);
       }
     } else {
       fprintf(stdout, "%c", c);
     }

     i = 0;
     memset(str1, 0, strlen(str1));
     memset(str2, 0, strlen(str2));
     memset(str3, 0, strlen(str3));
   }
  }
  if(isalpha(str1[0])) {
       str1[i] = '\0';
       str2[i] = '\0';
       str3[i] = '\0';
       if (findData(dictionary, str1) == NULL && findData(dictionary, str2) == NULL && findData(dictionary, str3) == NULL) {
         fprintf(stdout, "%s [sic]", str1);
       }
     }
  free(str1);
  free(str2);
  free(str3);
}
