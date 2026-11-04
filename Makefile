prepareEnv: buildContainers installBenchmarkDataset startMinikube applyManifests checkStatus openUrl

initAndRunExample: prepareEnv doExampleRequest

initAndRunBenchmark1: prepareEnv runBenchmark1
initAndRunBenchmark2: prepareEnv runBenchmark2
initAndRunBenchmark3: prepareEnv runBenchmark3
initAndRunBenchmark4: prepareEnv runBenchmark4
initAndRunBenchmarkPrompts0_10: prepareEnv runBenchmarkPrompts0_10
initAndRunBenchmarkPrompts30_50: prepareEnv runBenchmarkPrompts30_50
initAndRunBenchmarkPrompts70_100: prepareEnv runBenchmarkPrompts70_100
initAndRunBenchmarkAnswers0_10: prepareEnv runBenchmarkAnswers0_10
initAndRunBenchmarkAnswers50_100: prepareEnv runBenchmarkAnswers50_100
initAndRunBenchmarkAnswers500_1000: prepareEnv runBenchmarkAnswers500_1000

startMinikube:
	minikube start --memory=28g

stopMinikube:
	minikube stop
	minikube delete

buildContainers:
	docker build -t vllm-init-weights:latest -f initModelWeights/Dockerfile.initModelWeights initModelWeights
	docker build -t vllm-inference:latest -f inference/Dockerfile.inference inference

applyManifests:
	minikube image load vllm-init-weights:latest
	minikube image load vllm-inference:latest
	kubectl apply -k manifests

hotRerun:
	kubectl apply -k manifests
	kubectl delete pod -n vllm-inference vllm-0

checkStatus:
	kubectl rollout status statefulset/vllm -n vllm-inference --timeout=20m
	kubectl get pods,svc,pvc -n vllm-inference

openUrl:
	nohup kubectl port-forward -n vllm-inference svc/vllm-external 8000:8000 &

doExampleRequest:
	key=$$(kubectl get secret vllm-secrets -n vllm-inference -o jsonpath='{.data.VLLM_API_KEY}' | base64 -d); \
	curl -sS "http://localhost:8000/v1/chat/completions" \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer $$key" \
		-d '{"model":"/models/Qwen2.5-1.5B-Instruct","messages":[{"role":"user","content":"Say some long text"}],"max_tokens":128}'

doUnauthorizedExampleRequest:
	key="wrong_key"; \
	curl -sS "http://localhost:8000/v1/chat/completions" \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer $$key" \
		-d '{"model":"/models/Qwen2.5-1.5B-Instruct","messages":[{"role":"user","content":"Say some long text"}],"max_tokens":128}'

installBenchmarkDataset:
	hf download anon8231489123/ShareGPT_Vicuna_unfiltered \
		ShareGPT_V3_unfiltered_cleaned_split.json \
		--repo-type dataset \
		--local-dir .
	
	python3 split_sharegpt.py

runBenchmark1:
	key=$$(kubectl get secret vllm-secrets -n vllm-inference -o jsonpath='{.data.VLLM_API_KEY}' | base64 -d); \
	vllm bench serve \
		--backend vllm \
		--base-url "http://localhost:8000" \
		--header "Authorization=Bearer $$key" \
		--dataset-name sharegpt \
		--dataset-path ./ShareGPT_V3_unfiltered_cleaned_split.json \
		--tokenizer Qwen/Qwen2.5-1.5B-Instruct \
		--num-prompts 20 \
		--request-rate 1.0

runBenchmark2:
	key=$$(kubectl get secret vllm-secrets -n vllm-inference -o jsonpath='{.data.VLLM_API_KEY}' | base64 -d); \
	vllm bench serve \
		--backend vllm \
		--base-url "http://localhost:8000" \
		--header "Authorization=Bearer $$key" \
		--dataset-name sharegpt \
		--dataset-path ./ShareGPT_V3_unfiltered_cleaned_split.json \
		--tokenizer Qwen/Qwen2.5-1.5B-Instruct \
		--num-prompts 20 \
		--request-rate 0.5

runBenchmark3:
	key=$$(kubectl get secret vllm-secrets -n vllm-inference -o jsonpath='{.data.VLLM_API_KEY}' | base64 -d); \
	vllm bench serve \
		--backend vllm \
		--base-url "http://localhost:8000" \
		--header "Authorization=Bearer $$key" \
		--dataset-name sharegpt \
		--dataset-path ./ShareGPT_V3_unfiltered_cleaned_split.json \
		--tokenizer Qwen/Qwen2.5-1.5B-Instruct \
		--num-prompts 20 \
		--request-rate 0.1

runBenchmark4:
	key=$$(kubectl get secret vllm-secrets -n vllm-inference -o jsonpath='{.data.VLLM_API_KEY}' | base64 -d); \
	vllm bench serve \
		--backend vllm \
		--base-url "http://localhost:8000" \
		--header "Authorization=Bearer $$key" \
		--dataset-name sharegpt \
		--dataset-path ./ShareGPT_V3_unfiltered_cleaned_split.json \
		--tokenizer Qwen/Qwen2.5-1.5B-Instruct \
		--num-prompts 20 \
		--request-rate 5.0

runBenchmarkPrompts0_10:
	key=$$(kubectl get secret vllm-secrets -n vllm-inference -o jsonpath='{.data.VLLM_API_KEY}' | base64 -d); \
	vllm bench serve \
		--backend vllm \
		--base-url "http://localhost:8000" \
		--header "Authorization=Bearer $$key" \
		--dataset-name sharegpt \
		--dataset-path ./ShareGPT_V3_unfiltered_cleaned_split_prompts_0_10.json \
		--tokenizer Qwen/Qwen2.5-1.5B-Instruct \
		--num-prompts 20 \
		--request-rate 10.0

runBenchmarkPrompts30_50:
	key=$$(kubectl get secret vllm-secrets -n vllm-inference -o jsonpath='{.data.VLLM_API_KEY}' | base64 -d); \
	vllm bench serve \
		--backend vllm \
		--base-url "http://localhost:8000" \
		--header "Authorization=Bearer $$key" \
		--dataset-name sharegpt \
		--dataset-path ./ShareGPT_V3_unfiltered_cleaned_split_prompts_30_50.json \
		--tokenizer Qwen/Qwen2.5-1.5B-Instruct \
		--num-prompts 20 \
		--request-rate 5.0

runBenchmarkPrompts70_100:
	key=$$(kubectl get secret vllm-secrets -n vllm-inference -o jsonpath='{.data.VLLM_API_KEY}' | base64 -d); \
	vllm bench serve \
		--backend vllm \
		--base-url "http://localhost:8000" \
		--header "Authorization=Bearer $$key" \
		--dataset-name sharegpt \
		--dataset-path ./ShareGPT_V3_unfiltered_cleaned_split_prompts_70_100.json \
		--tokenizer Qwen/Qwen2.5-1.5B-Instruct \
		--num-prompts 20 \
		--request-rate 1.0

runBenchmarkAnswers0_10:
	key=$$(kubectl get secret vllm-secrets -n vllm-inference -o jsonpath='{.data.VLLM_API_KEY}' | base64 -d); \
	vllm bench serve \
		--backend vllm \
		--base-url "http://localhost:8000" \
		--header "Authorization=Bearer $$key" \
		--dataset-name sharegpt \
		--dataset-path ./ShareGPT_V3_unfiltered_cleaned_split_answers_0_10.json \
		--tokenizer Qwen/Qwen2.5-1.5B-Instruct \
		--num-prompts 20 \
		--request-rate 10.0

runBenchmarkAnswers50_100:
	key=$$(kubectl get secret vllm-secrets -n vllm-inference -o jsonpath='{.data.VLLM_API_KEY}' | base64 -d); \
	vllm bench serve \
		--backend vllm \
		--base-url "http://localhost:8000" \
		--header "Authorization=Bearer $$key" \
		--dataset-name sharegpt \
		--dataset-path ./ShareGPT_V3_unfiltered_cleaned_split_answers_50_100.json \
		--tokenizer Qwen/Qwen2.5-1.5B-Instruct \
		--num-prompts 20 \
		--request-rate 5.0

runBenchmarkAnswers500_1000:
	key=$$(kubectl get secret vllm-secrets -n vllm-inference -o jsonpath='{.data.VLLM_API_KEY}' | base64 -d); \
	vllm bench serve \
		--backend vllm \
		--base-url "http://localhost:8000" \
		--header "Authorization=Bearer $$key" \
		--dataset-name sharegpt \
		--dataset-path ./ShareGPT_V3_unfiltered_cleaned_split_answers_500_1000.json \
		--tokenizer Qwen/Qwen2.5-1.5B-Instruct \
		--num-prompts 20 \
		--request-rate 1.0