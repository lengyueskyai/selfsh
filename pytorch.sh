python - <<'PY'
import torch
import 
time
import random
import gc

base_gb = 80
min_extra_gb = 0
max_extra_gb = 3

print("开始：基础 24GB + 随机 0~3GB 波动，Ctrl+C 停止"
)

base = torch.empty(
    base_gb * 1024 * 1024 * 1024 // 4,
    dtype=torch.float32,
    device=
"cuda"
)
base.fill_(1.0)

print("✅ 基础占用 80GB 成功"
)

while
 True:
    extra_gb = random.uniform(min_extra_gb, max_extra_gb)
    hold_seconds = random.randint(3, 15)
    idle_seconds = random.randint(1, 8)

    num_floats = int(extra_gb * 1024 * 1024 * 1024 // 4)

    if
 num_floats > 0:
        extra = torch.empty(
            num_floats,
            dtype=torch.float32,
            device=
"cuda"
        )
        extra.fill_(1.0)

        print(f"📈 当前约 {base_gb + extra_gb:.2f}GB，保持 {hold_seconds}s"
)
        time.sleep(hold_seconds)

        del extra
        gc.collect()
        torch.cuda.empty_cache()

        print(f"📉 回落到基础约 {base_gb}GB，等待 {idle_seconds}s"
)
        time.sleep(idle_seconds)
    else
:
        print(f"📉 当前约 {base_gb}GB，等待 {idle_seconds}s"
)
        gc.collect()
        torch.cuda.empty_cache()
        time.sleep(idle_seconds)
PY
