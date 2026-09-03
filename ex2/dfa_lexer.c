#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define MAX_STATES 20
#define MAX_SYMBOLS 10
#define MAX_STRING 50

int get_symbol_index(char symbol, char alphabet[], int num_symbols) {
    for (int i = 0; i < num_symbols; i++) {
        if (alphabet[i] == symbol) {
            return i;
        }
    }
    return -1;
}

int main() {
    int num_states, num_symbols, num_accepting;
    int start_state;
    char alphabet[MAX_SYMBOLS];
    bool is_accepting[MAX_STATES] = {false};
    int transition_table[MAX_STATES][MAX_SYMBOLS];
    char input_string[MAX_STRING];

    printf("Enter the total number of states: ");
    if (scanf("%d", &num_states) != 1) return 1;

    printf("Enter the number of input symbols: ");
    if (scanf("%d", &num_symbols) != 1) return 1;

    printf("Enter the input symbols separated by space (e.g., a b): ");
    for (int i = 0; i < num_symbols; i++) {
        scanf(" %c", &alphabet[i]);
    }

    printf("Enter the start state (0 to %d): ", num_states - 1);
    if (scanf("%d", &start_state) != 1) return 1;

    printf("Enter the number of accepting states: ");
    if (scanf("%d", &num_accepting) != 1) return 1;

    printf("Enter the accepting states separated by space: ");
    for (int i = 0; i < num_accepting; i++) {
        int state;
        scanf("%d", &state);
        if (state >= 0 && state < num_states) {
            is_accepting[state] = true;
        }
    }

    printf("\n--- Enter Transition Table ---\n");
    printf("Use -1 for an undefined transition.\n\n");
    printf("State   | ");
    for (int j = 0; j < num_symbols; j++) {
        printf("%c   ", alphabet[j]);
    }
    printf("\n--------|---------");
    printf("\n");

    for (int i = 0; i < num_states; i++) {
        char prefix[10] = "";
        if (i == start_state) {
            strcat(prefix, "->");
        }
        if (is_accepting[i]) {
            strcat(prefix, "*");
        }

        printf("%-3sq%-4d| ", prefix, i);
        for (int j = 0; j < num_symbols; j++) {
            scanf("%d", &transition_table[i][j]);
        }
    }

    printf("\n--- DFA Configuration Complete ---\n");
    while (1) {
        printf("\nEnter an input string to test (or type 'exit' to quit): ");
        if (scanf("%s", input_string) != 1) break;

        if (strcmp(input_string, "exit") == 0) {
            break;
        }

        int len = strlen(input_string);
        if (len == 0) continue;

        char token_buffer[MAX_STRING];
        int buf_idx = 0;

        bool is_current_valid = (get_symbol_index(input_string[0], alphabet, num_symbols) != -1);

        for (int i = 0; i <= len; i++) {
            bool is_char_valid = (input_string[i] != '\0') && (get_symbol_index(input_string[i], alphabet, num_symbols) != -1);

            if (input_string[i] != '\0' && (is_char_valid == is_current_valid) && is_current_valid) {
                token_buffer[buf_idx++] = input_string[i];
            } else {
                if (buf_idx == 0 && input_string[i] != '\0' && !is_current_valid) {
                    token_buffer[buf_idx++] = input_string[i];
                    i++;
                }

                token_buffer[buf_idx] = '\0';

                if (buf_idx > 0) {
                    if (is_current_valid) {
                        int temp_state = start_state;
                        bool dead_state_hit = false;
                        int valid_stop_index = 0;
                        int last_valid_state = start_state;

                        for (int k = 0; token_buffer[k] != '\0'; k++) {
                            if (temp_state == -1) {
                                dead_state_hit = true;
                                break;
                            }
                            int sym_idx = get_symbol_index(token_buffer[k], alphabet, num_symbols);
                            temp_state = transition_table[temp_state][sym_idx];

                            // Track the position and state if we move to a valid state
                            if (temp_state != -1) {
                                last_valid_state = temp_state;
                                valid_stop_index = k + 1; // 1-based character position tracker
                            }
                        }

                        if (!dead_state_hit && temp_state != -1 && is_accepting[temp_state]) {
                            printf("recognized token<%s> [Ends at char index: %d, Final Stage: q%d]\n",
                                   token_buffer, valid_stop_index, temp_state);
                        } else {
                            printf("unrecognized token<%s> [Stopped at char index: %d, Last Valid Stage: q%d]\n",
                                   token_buffer, valid_stop_index, last_valid_state);
                        }
                    } else {
                        printf("unrecognized token<%s>\n", token_buffer);
                    }
                }

                if (input_string[i] != '\0') {
                    token_buffer[0] = input_string[i];
                    token_buffer[1] = '\0';
                    buf_idx = 1;
                    is_current_valid = (get_symbol_index(input_string[i], alphabet, num_symbols) != -1);
                } else {
                    buf_idx = 0;
                }
            }
        }
        printf("\n");
    }

    return 0;
}
