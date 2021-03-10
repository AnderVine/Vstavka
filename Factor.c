const char* usage = "Usage: \n"
                        "\t./factor <number>\n"
                        "\t-2^31 <= number <= 2^31\n";

const char* overflow = "Given number is too big.\n";

extern int print_str(const char* str, int length);
extern int print_int(int number);
extern int print_char(char c);

int strlen(const char* str)
{
    int len = 0;
    while (*str != '\0')
    {
        len++;
        str++;
    }
    return len;
}

int is_num(const char* str)
{
    if (*str == '-' || *str == '+')
    {
        str++;
    }

    while (*str != '\0')
    {
        if (*str >= '0' && *str <= '9')
        {
            str++;
            continue;
        }
        return 0;
    }
    return 1;
}

// atoi makes int from string
// returns 1 if number is too big
// and 0 if everything is ok
int atoi(const char* str, int *num)
{
    int sign = 1;
    switch (*str) {
    case '-':
        sign = -1;
        str++;
        break;
    case '+':
        str++;
        break;
    }

    *num = 0;
    while (*str != '\0')
    {
        int prev_num = *num;
        *num *= 10;
        *num -= *str - '0';
        if (*num > prev_num || (*num + (*str - '0')) / 10 != prev_num) // second check is done to avoid double overflow
        {
            return 1; // overflow
        }
        str++;
    }

    if (sign == 1 && *num == -2147483648)
    {
        return 1; // overflow
    }

    *num *= -sign; // there is minus because we formed a negative number
    return 0;
}

void factor(int num)
{
    if (num == 1 || num == 0)
    {
        print_int(num);
        return;
    }

    if (num < 0)
    {
        print_int(-1);
        print_char(' ');
    }

    for (int i = 2; num != 1 && num != -1; )
    {
        if (num % i == 0)
        {
            print_int(i);
            print_char(' ');
            num /= i;
            continue;
        }
        i++;
    }
}

int main(int argc, char** argv)
{
    if (argc != 2 || !is_num(argv[1]))
    {
        print_str(usage, strlen(usage));
        return -1;
    }

    int num = 0;
    int err = atoi(argv[1], &num);
    if (err) {
        print_str(overflow, strlen(overflow));
        print_char('\n');
        print_str(usage, strlen(usage));
        return -1;
    }

    factor(num);
    print_char('\n');
    return 0;
}