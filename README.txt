CODENAMES AI Version 1.0

This program generates clues based on either 8 or 9 words entered by the user. The words must be taken from the 400-word set of the Codenames board game. The clues are generated based on an analysis of the Priceton Wordnet database which was partially mapped to .mat files and stored in the Database folder.

TO RUN:

1. Open "GiveClues.m" in MATLAB.
2. Add the "Database" folder to the MATLAB path.
3. Run the program.

The user will be prompted to enter either 8 or 9 codenames. Once these clues are entered, the program will use the database to select the best clue which describes one or more words in the set along with the number of words described by the given clue. The format with which it returns the clue is [Word, # Words].

After the clue is given, the user is prompted to enter the number of codenames guessed correctly by the other player(s) and enter the codenames that were guessed correctly. The program will then generate a new clue based on the modified codenames set. If no words were guessed correctly, the user may enter the number 0 in order to obtain a new clue.

FUTURE WORK:

1. Adding machine learning functionality to the program. The framework for machine learning functionality is included in this version, however it was not yet implemented due to the difficulty in obtaining a large Codenames gameplay dataset.

2. Adding the ability to enter the other codenames on the board in order to avoid giving a clue which might lead to an undesirable response.

3. More efficient and effective clue-generating algorithms.
