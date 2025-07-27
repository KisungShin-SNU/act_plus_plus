#!/bin/bash

start_time=$(date '+%s')

# 공통 인자
TASK_NAME="aloha_mobile_emart_bag"
CKPT_DIR="ckpt_aloha_mobile_emart_bag"
POLICY_CLASS="ACT"
KL_WEIGHT=10
CHUNK_SIZE=50
HIDDEN_DIM=512
BATCH_SIZE=8
DIM_FEEDFORWARD=3200
NUM_STEPS=5000
LR=1e-5
SEED=0
CKPT_BASE="/home/work/.jinupahk/virtualkss/act_plus_plus/act_plus_plus/${CKPT_DIR}"
FINAL_STEPS=500000

# 실행 함수 (Segfault 발생 시 재시도)
run_with_retry() {
    local cmd="$1"
    local max_retries=10000
    local count=0
    local exit_code=0

    while true; do
        eval "$cmd"
        exit_code=$?

        # 139는 segmentation fault의 일반적인 종료 코드
        if [ $exit_code -ne 139 ]; then
            break
        fi

        echo "Segmentation fault detected. Retrying ($count/$max_retries)..."
        count=$((count + 1))

        if [ $count -ge $max_retries ]; then
            echo "Reached maximum retry limit. Giving up."
            break
        fi
        sleep 1
    done
}

# 최초 실행 (resume 없이)
CMD="CUDA_VISIBLE_DEVICES=0 python3 imitate_episodes.py \
    --task_name $TASK_NAME \
    --ckpt_dir $CKPT_DIR \
    --policy_class $POLICY_CLASS \
    --kl_weight $KL_WEIGHT \
    --chunk_size $CHUNK_SIZE \
    --hidden_dim $HIDDEN_DIM \
    --batch_size $BATCH_SIZE \
    --dim_feedforward $DIM_FEEDFORWARD \
    --num_steps $NUM_STEPS \
    --lr $LR \
    --seed $SEED"
run_with_retry "$CMD"

# resume 실행 루프
for STEP in $(seq $NUM_STEPS $NUM_STEPS $FINAL_STEPS); do
    CKPT_PATH="${CKPT_BASE}/policy_step_${STEP}_seed_${SEED}.ckpt"
    CMD="CUDA_VISIBLE_DEVICES=0 python3 imitate_episodes.py \
        --task_name $TASK_NAME \
        --ckpt_dir $CKPT_DIR \
        --policy_class $POLICY_CLASS \
        --kl_weight $KL_WEIGHT \
        --chunk_size $CHUNK_SIZE \
        --hidden_dim $HIDDEN_DIM \
        --batch_size $BATCH_SIZE \
        --dim_feedforward $DIM_FEEDFORWARD \
        --num_steps $NUM_STEPS \
        --lr $LR \
        --seed $SEED \
        --resume_ckpt_path $CKPT_PATH"
    run_with_retry "$CMD"
done


end_time=$(date '+%s')

diff=$((end_time - start_time))
hour=$((diff / 3600 % 24))
minute=$((diff / 60 % 60))
second=$((diff % 60))

echo "$hour 시간 $minute 분 $second 초"