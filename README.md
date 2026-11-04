# vllmInMinikube

## Commands

```bash
# Полноценные запуски без нужды запускать что-то дополнительное:
make initAndRunExample                       # prepareEnv и пример запроса
make initAndRunBenchmark1                    # prepareEnv и бенч ShareGPT, request-rate 1.0
make initAndRunBenchmark2                    # prepareEnv и бенч ShareGPT, request-rate 0.5
make initAndRunBenchmark3                    # prepareEnv и бенч ShareGPT, request-rate 0.1
make initAndRunBenchmark4                    # prepareEnv и бенч ShareGPT, request-rate 5.0
make initAndRunBenchmarkPrompts0_10          # prepareEnv и бенч, вопросы 0-10 слов
make initAndRunBenchmarkPrompts30_50         # prepareEnv и бенч, вопросы 30-50 слов
make initAndRunBenchmarkPrompts70_100        # prepareEnv и бенч, вопросы 70-100 слов
make initAndRunBenchmarkAnswers0_10          # prepareEnv и бенч, ответы 0-10 слов
make initAndRunBenchmarkAnswers50_100        # prepareEnv и бенч, ответы 50-100 слов
make initAndRunBenchmarkAnswers500_1000      # prepareEnv и бенч, ответы 500-1000 слов

make prepareEnv                              # собрать образы, поднять minikube, применить manifests/ и пробросить порт
make startMinikube                           # поднять minikube
make stopMinikube                            # остановить и удалить minikube
make buildContainers                         # собрать образы
make applyManifests                          # загрузить образы и применить manifests/
make hotRerun                                # применить manifests/ и пересоздать под
make checkStatus                             # дождаться готовности и показать ресурсы
make openUrl                                 # пробросить сервис на localhost:8000
make doExampleRequest                        # пример запроса в /v1/chat/completions
make doUnauthorizedExampleRequest            # тот же запрос с неверным ключом
make installBenchmarkDataset                 # скачать ShareGPT для нагрузочного теста

make runBenchmark1                           # бенч ShareGPT, request-rate 1.0
make runBenchmark2                           # бенч ShareGPT, request-rate 0.5
make runBenchmark3                           # бенч ShareGPT, request-rate 0.1
make runBenchmark4                           # бенч ShareGPT, request-rate 5.0
make runBenchmarkPrompts0_10                 # бенч, вопросы 0-10 слов, request-rate 10.0
make runBenchmarkPrompts30_50                # бенч, вопросы 30-50 слов, request-rate 5.0
make runBenchmarkPrompts70_100               # бенч, вопросы 70-100 слов, request-rate 1.0
make runBenchmarkAnswers0_10                 # бенч, ответы 0-10 слов, request-rate 10.0
make runBenchmarkAnswers50_100               # бенч, ответы 50-100 слов, request-rate 5.0
make runBenchmarkAnswers500_1000             # бенч, ответы 500-1000 слов, request-rate 1.0
```



## Benchmarks compression before->after tune


| Benchmark        | Output tok/s           | Total tok/s               | Mean TTFT                  | Mean ITL                |
| ---------------- | ---------------------- | ------------------------- | -------------------------- | ----------------------- |
| Prompts 0-10     | 27.74 -> 28.35 (+2.2%) | 28.57 -> 29.15 (+2.0%)    | 2920 -> 2982 мс (+2.1%)    | 458 -> 476 мс (+3.8%)   |
| Prompts 70-100   | 19.55 -> 19.22 (-1.7%) | 28.46 -> 28.16 (-1.1%)    | 40853 -> 53572 мс (+31.1%) | 535 -> 498 мс (-7.0%)   |
| Answers 0-10     | 3.64 -> 8.91 (+144.8%) | 34.60 -> 120.72 (+248.9%) | 78478 -> 16885 мс (-78.5%) | 2014 -> 440 мс (-78.2%) |
| Answers 500-1000 | 26.49 -> 26.87 (+1.4%) | 29.68 -> 30.22 (+1.8%)    | 14678 -> 14530 мс (-1.0%)  | 624 -> 596 мс (-4.6%)   |



| Benchmark        | Duration                   | Request throughput     |
| ---------------- | -------------------------- | ---------------------- |
| Prompts 0-10     | 221.96 -> 228.59 с (+3.0%) | 0.090 -> 0.087 (-2.9%) |
| Prompts 70-100   | 293.53 -> 292.59 с (-0.3%) | 0.068 -> 0.068 (+0.3%) |
| Answers 0-10     | 153.23 -> 42.43 с (-72.3%) | 0.131 -> 0.471 (+261%) |
| Answers 500-1000 | 488.42 -> 464.87 с (-4.8%) | 0.041 -> 0.043 (+5.1%) |




## Full benchmarks outputs before any tune



## BenchmarkPrompts0_10

```bash
make runBenchmarkPrompts0_10
```

```text
============ Serving Benchmark Result ============
Successful requests:                     20
Failed requests:                         0
Request rate configured (RPS):           10.00
Benchmark duration (s):                  221.96
Total input tokens:                      183
Total generated tokens:                  6158
Request throughput (req/s):              0.09
Output token throughput (tok/s):         27.74
Peak output token throughput (tok/s):    45.00
Peak concurrent requests:                20.00
Total token throughput (tok/s):          28.57
---------------Time to First Token----------------
Mean TTFT (ms):                          2919.97
Median TTFT (ms):                        3246.62
P99 TTFT (ms):                           4119.14
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          508.26
Median TPOT (ms):                        498.87
P99 TPOT (ms):                           672.71
---------------Inter-token Latency----------------
Mean ITL (ms):                           458.47
Median ITL (ms):                         482.69
P99 ITL (ms):                            657.02
==================================================
```



## BenchmarkPrompts30_50

```bash
make runBenchmarkPrompts30_50
```

```text
============ Serving Benchmark Result ============
Successful requests:                     20        
Failed requests:                         0         
Request rate configured (RPS):           5.00      
Benchmark duration (s):                  308.59    
Total input tokens:                      952       
Total generated tokens:                  7837      
Request throughput (req/s):              0.06      
Output token throughput (tok/s):         25.40     
Peak output token throughput (tok/s):    40.00     
Peak concurrent requests:                20.00     
Total token throughput (tok/s):          28.48     
---------------Time to First Token----------------
Mean TTFT (ms):                          16839.70  
Median TTFT (ms):                        21944.41  
P99 TTFT (ms):                           23469.54  
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          560.38    
Median TPOT (ms):                        590.92    
P99 TPOT (ms):                           746.51    
---------------Inter-token Latency----------------
Mean ITL (ms):                           503.37    
Median ITL (ms):                         545.11    
P99 ITL (ms):                            745.41    
==================================================
```



## BenchmarkPrompts70_100

```bash
make runBenchmarkPrompts70_100
```

```text
============ Serving Benchmark Result ============
Successful requests:                     20        
Failed requests:                         0         
Request rate configured (RPS):           1.00      
Benchmark duration (s):                  293.53    
Total input tokens:                      2614      
Total generated tokens:                  5739      
Request throughput (req/s):              0.07      
Output token throughput (tok/s):         19.55     
Peak output token throughput (tok/s):    40.00     
Peak concurrent requests:                20.00     
Total token throughput (tok/s):          28.46     
---------------Time to First Token----------------
Mean TTFT (ms):                          40853.00  
Median TTFT (ms):                        47534.36  
P99 TTFT (ms):                           56961.50  
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          617.42    
Median TPOT (ms):                        603.03    
P99 TPOT (ms):                           1032.31   
---------------Inter-token Latency----------------
Mean ITL (ms):                           534.84    
Median ITL (ms):                         544.25    
P99 ITL (ms):                            820.43    
==================================================
```



## BenchmarkAnswers0_10

```bash
make runBenchmarkAnswers0_10
```

```text
============ Serving Benchmark Result ============
Successful requests:                     20        
Failed requests:                         0         
Request rate configured (RPS):           10.00     
Benchmark duration (s):                  153.23    
Total input tokens:                      4744      
Total generated tokens:                  558       
Request throughput (req/s):              0.13      
Output token throughput (tok/s):         3.64      
Peak output token throughput (tok/s):    39.00     
Peak concurrent requests:                20.00     
Total token throughput (tok/s):          34.60     
---------------Time to First Token----------------
Mean TTFT (ms):                          78477.91  
Median TTFT (ms):                        70844.22  
P99 TTFT (ms):                           125984.90 
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          7414.47   
Median TPOT (ms):                        4088.00   
P99 TPOT (ms):                           33436.28  
---------------Inter-token Latency----------------
Mean ITL (ms):                           2014.02   
Median ITL (ms):                         126.11    
P99 ITL (ms):                            55838.90  
```



## BenchmarkAnswers50_100

```bash
make runBenchmarkAnswers50_100
```

```text
============ Serving Benchmark Result ============
Successful requests:                     20        
Failed requests:                         0         
Request rate configured (RPS):           5.00      
Benchmark duration (s):                  174.99    
Total input tokens:                      3534      
Total generated tokens:                  2306      
Request throughput (req/s):              0.11      
Output token throughput (tok/s):         13.18     
Peak output token throughput (tok/s):    40.00     
Peak concurrent requests:                20.00     
Total token throughput (tok/s):          33.37     
---------------Time to First Token----------------
Mean TTFT (ms):                          65406.60  
Median TTFT (ms):                        56864.32  
P99 TTFT (ms):                           90297.50  
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          808.21    
Median TPOT (ms):                        719.26    
P99 TPOT (ms):                           1289.58   
---------------Inter-token Latency----------------
Mean ITL (ms):                           738.92    
Median ITL (ms):                         633.55    
P99 ITL (ms):                            783.17    
==================================================
```



## BenchmarkAnswers500_1000

```bash
make runBenchmarkAnswers500_1000
```

```text
============ Serving Benchmark Result ============
Successful requests:                     20        
Failed requests:                         0         
Request rate configured (RPS):           1.00      
Benchmark duration (s):                  488.42    
Total input tokens:                      1559      
Total generated tokens:                  12936     
Request throughput (req/s):              0.04      
Output token throughput (tok/s):         26.49     
Peak output token throughput (tok/s):    40.00     
Peak concurrent requests:                20.00     
Total token throughput (tok/s):          29.68     
---------------Time to First Token----------------
Mean TTFT (ms):                          14677.72  
Median TTFT (ms):                        13658.60  
P99 TTFT (ms):                           29218.57  
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          637.27    
Median TPOT (ms):                        624.06    
P99 TPOT (ms):                           818.85    
---------------Inter-token Latency----------------
Mean ITL (ms):                           624.36    
Median ITL (ms):                         608.42    
P99 ITL (ms):                            854.54    
==================================================
```



## Benchmark1 (request-rate 1.0)

```bash
make runBenchmark1
```

```text
============ Serving Benchmark Result ============
Successful requests:                     20
Failed requests:                         0
Request rate configured (RPS):           1.00
Benchmark duration (s):                  313.53
Total input tokens:                      4270
Total generated tokens:                  4965
Request throughput (req/s):              0.06
Output token throughput (tok/s):         15.84
Peak output token throughput (tok/s):    40.00
Peak concurrent requests:                20.00
Total token throughput (tok/s):          29.45
---------------Time to First Token----------------
Mean TTFT (ms):                          63723.07
Median TTFT (ms):                        77411.79
P99 TTFT (ms):                           105495.69
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          1676.01
Median TPOT (ms):                        700.95
P99 TPOT (ms):                           11003.82
---------------Inter-token Latency----------------
Mean ITL (ms):                           542.41
Median ITL (ms):                         369.13
P99 ITL (ms):                            749.61
==================================================
```



## Benchmark2 (request-rate 0.5)

```bash
make runBenchmark2
```

```text
============ Serving Benchmark Result ============
Successful requests:                     20
Failed requests:                         0
Request rate configured (RPS):           0.50
Benchmark duration (s):                  206.49
Total input tokens:                      4270
Total generated tokens:                  4996
Request throughput (req/s):              0.10
Output token throughput (tok/s):         24.19
Peak output token throughput (tok/s):    42.00
Peak concurrent requests:                17.00
Total token throughput (tok/s):          44.87
---------------Time to First Token----------------
Mean TTFT (ms):                          1769.55
Median TTFT (ms):                        1182.87
P99 TTFT (ms):                           4012.18
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          411.09
Median TPOT (ms):                        435.66
P99 TPOT (ms):                           587.97
---------------Inter-token Latency----------------
Mean ITL (ms):                           339.13
Median ITL (ms):                         294.24
P99 ITL (ms):                            930.34
==================================================
```



## Benchmark3 (request-rate 0.1)

```bash
make runBenchmark3
```

```text
============ Serving Benchmark Result ============
Successful requests:                     19
Failed requests:                         1
Request rate configured (RPS):           0.10
Benchmark duration (s):                  286.17
Total input tokens:                      3868
Total generated tokens:                  4702
Request throughput (req/s):              0.07
Output token throughput (tok/s):         16.43
Peak output token throughput (tok/s):    33.00
Peak concurrent requests:                7.00
Total token throughput (tok/s):          29.95
---------------Time to First Token----------------
Mean TTFT (ms):                          1125.54
Median TTFT (ms):                        734.43
P99 TTFT (ms):                           3165.70
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          194.23
Median TPOT (ms):                        177.60
P99 TPOT (ms):                           543.80
---------------Inter-token Latency----------------
Mean ITL (ms):                           161.54
Median ITL (ms):                         144.88
P99 ITL (ms):                            392.47
==================================================
```



## Benchmark4 (request-rate 5)

```bash
make runBenchmark4
```

```text
============ Serving Benchmark Result ============
Successful requests:                     20
Failed requests:                         0
Request rate configured (RPS):           5.00
Benchmark duration (s):                  197.48
Total input tokens:                      4270
Total generated tokens:                  4730
Request throughput (req/s):              0.10
Output token throughput (tok/s):         23.95
Peak output token throughput (tok/s):    39.00
Peak concurrent requests:                20.00
Total token throughput (tok/s):          45.57
---------------Time to First Token----------------
Mean TTFT (ms):                          9456.50
Median TTFT (ms):                        11571.91
P99 TTFT (ms):                           13283.16
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          534.14
Median TPOT (ms):                        493.76
P99 TPOT (ms):                           1324.48
---------------Inter-token Latency----------------
Mean ITL (ms):                           374.53
Median ITL (ms):                         374.49
P99 ITL (ms):                            721.61
==================================================
```



## Full benchmarks outputs after tune



## BenchmarkPrompts0_10

```bash
make runBenchmarkPrompts0_10
```

```text
============ Serving Benchmark Result ============
Successful requests:                     20        
Failed requests:                         0         
Request rate configured (RPS):           10.00     
Benchmark duration (s):                  228.59    
Total input tokens:                      183       
Total generated tokens:                  6481      
Request throughput (req/s):              0.09      
Output token throughput (tok/s):         28.35     
Peak output token throughput (tok/s):    42.00     
Peak concurrent requests:                20.00     
Total token throughput (tok/s):          29.15     
---------------Time to First Token----------------
Mean TTFT (ms):                          2982.35   
Median TTFT (ms):                        3695.92   
P99 TTFT (ms):                           4458.72   
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          519.70    
Median TPOT (ms):                        531.26    
P99 TPOT (ms):                           649.89    
---------------Inter-token Latency----------------
Mean ITL (ms):                           475.74    
Median ITL (ms):                         542.59    
P99 ITL (ms):                            698.53    
==================================================
```



## BenchmarkPrompts70_100

```bash
make runBenchmarkPrompts70_100
```

```text
============ Serving Benchmark Result ============
Successful requests:                     20        
Failed requests:                         0         
Request rate configured (RPS):           1.00      
Benchmark duration (s):                  292.59    
Total input tokens:                      2614      
Total generated tokens:                  5624      
Request throughput (req/s):              0.07      
Output token throughput (tok/s):         19.22     
Peak output token throughput (tok/s):    42.00     
Peak concurrent requests:                20.00     
Total token throughput (tok/s):          28.16     
---------------Time to First Token----------------
Mean TTFT (ms):                          53571.76  
Median TTFT (ms):                        53293.15  
P99 TTFT (ms):                           67525.10  
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          613.92    
Median TPOT (ms):                        588.01    
P99 TPOT (ms):                           1129.78   
---------------Inter-token Latency----------------
Mean ITL (ms):                           497.53    
Median ITL (ms):                         498.64    
P99 ITL (ms):                            687.12    
==================================================
```



## BenchmarkAnswers0_10

```bash
make runBenchmarkAnswers0_10
```

```text
============ Serving Benchmark Result ============
Successful requests:                     20        
Failed requests:                         0         
Request rate configured (RPS):           10.00     
Benchmark duration (s):                  42.43     
Total input tokens:                      4744      
Total generated tokens:                  378       
Request throughput (req/s):              0.47      
Output token throughput (tok/s):         8.91      
Peak output token throughput (tok/s):    40.00     
Peak concurrent requests:                20.00     
Total token throughput (tok/s):          120.72    
---------------Time to First Token----------------
Mean TTFT (ms):                          16884.66  
Median TTFT (ms):                        19229.48  
P99 TTFT (ms):                           20306.29  
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          935.54    
Median TPOT (ms):                        522.60    
P99 TPOT (ms):                           5481.73   
---------------Inter-token Latency----------------
Mean ITL (ms):                           439.65    
Median ITL (ms):                         132.97    
P99 ITL (ms):                            1657.94   
==================================================
```



## BenchmarkAnswers500_1000

```bash
make runBenchmarkAnswers500_1000
```

```text
============ Serving Benchmark Result ============
Successful requests:                     20        
Failed requests:                         0         
Request rate configured (RPS):           1.00      
Benchmark duration (s):                  464.87    
Total input tokens:                      1559      
Total generated tokens:                  12490     
Request throughput (req/s):              0.04      
Output token throughput (tok/s):         26.87     
Peak output token throughput (tok/s):    42.00     
Peak concurrent requests:                20.00     
Total token throughput (tok/s):          30.22     
---------------Time to First Token----------------
Mean TTFT (ms):                          14530.17  
Median TTFT (ms):                        13476.55  
P99 TTFT (ms):                           28963.03  
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          634.17    
Median TPOT (ms):                        591.94    
P99 TPOT (ms):                           1056.46   
---------------Inter-token Latency----------------
Mean ITL (ms):                           595.94    
Median ITL (ms):                         599.47    
P99 ITL (ms):                            659.89    
==================================================
```

