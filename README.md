# benford

```
Usage: benford.sh CSDN_ID     # check csdn blog view count
       benford.sh -r FILE     # check local raw data
Check whether the data meets Benford's law.
```

example output:

```
$ ./benford.sh 
csdn id: imred
url prefix: https://blog.csdn.net/imred/article/list/
page size: 40
list total: 112
page count: 3

[1/3]: https://blog.csdn.net/imred/article/list/1 --> <stdout>
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 93634    0 93634    0     0   195k      0 --:--:-- --:--:-- --:--:--  195k

[2/3]: https://blog.csdn.net/imred/article/list/2 --> <stdout>
100 90141    0 90141    0     0   444k      0 --:--:-- --:--:-- --:--:--  444k

[3/3]: https://blog.csdn.net/imred/article/list/3 --> <stdout>
100 80071    0 80071    0     0   485k      0 --:--:-- --:--:-- --:--:--  485k
   30.10% ++++++++++++++++++++++++++++++
1  37.50% =====================================
   17.61% +++++++++++++++++
2  16.07% ================
   12.49% ++++++++++++
3  13.39% =============
    9.69% +++++++++
4   9.82% =========
    7.92% +++++++
5   6.25% ======
    6.69% ++++++
6   5.36% =====
    5.80% +++++
7   6.25% ======
    5.12% +++++
8   3.57% ===
    4.58% ++++
9   1.79% =
```

```
$ ./benford.sh -r raw.txt
   30.10% ++++++++++++++++++++++++++++++
1  20.00% ====================
   17.61% +++++++++++++++++
2   0.00%
   12.49% ++++++++++++
3  20.00% ====================
    9.69% +++++++++
4   0.00%
    7.92% +++++++
5  20.00% ====================
    6.69% ++++++
6   0.00%
    5.80% +++++
7  20.00% ====================
    5.12% +++++
8   0.00%
    4.58% ++++
9  20.00% ====================
```

'+' represents the expected value calculated by Benford's law, '=' represents the actual value.