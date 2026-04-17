# Runpod vLLM base

Ce projet construit une image Runpod qui lance `vllm` via le script [`start-vllm.sh`](/home/lawilfart/Documents/runpod-vllm-base/start-vllm.sh).

## Variables d'environnement

Variable obligatoire :

- `MODEL_NAME`

Variables optionnelles :

- `HOST` par defaut `0.0.0.0`
- `PORT` par defaut `8000`
- `API_KEY` par defaut `token-abc123`
- `DTYPE` par defaut `auto`
- `MAX_MODEL_LEN` par defaut `8192`
- `GPU_MEMORY_UTILIZATION` par defaut `0.95`
- `TENSOR_PARALLEL_SIZE` par defaut `1`
- `TRUST_REMOTE_CODE` par defaut `false`
- `EXTRA_ARGS` pour passer des flags supplementaires a vLLM

## Cause de l'erreur observee

L'erreur ou `vLLM` essayait de charger `/bin/bash` comme modele venait du fait que l'image de base definit deja son propre `ENTRYPOINT`.

Avec l'ancien `Dockerfile`, la ligne `CMD ["/bin/bash"]` n'executait pas un shell interactif. Elle etait transmise a l'`ENTRYPOINT` de l'image de base, qui l'interpretait comme argument du serveur vLLM, donc comme valeur de `--model`.

Le `Dockerfile` a ete corrige pour utiliser directement `start-vllm.sh` comme `ENTRYPOINT`.

## Exemples

Lancement minimal :

```bash
docker run --rm -p 8000:8000 \
  -e MODEL_NAME=google/gemma-3-12b-it \
  <image>
```

Avec options :

```bash
docker run --rm -p 8000:8000 \
  -e MODEL_NAME=google/gemma-3-12b-it \
  -e API_KEY=my-secret \
  -e MAX_MODEL_LEN=16384 \
  -e EXTRA_ARGS="--enable-prefix-caching" \
  <image>
```
