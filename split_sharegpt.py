import json

RANGES = {
    "prompts": ((0, 10), (30, 50), (70, 100)),
    "answers": ((0, 10), (50, 100), (500, 1000)),
}
SOURCE = "ShareGPT_V3_unfiltered_cleaned_split.json"
PREFIX = "ShareGPT_V3_unfiltered_cleaned_split"

def words(text):
    return len(text.split())

# Тут немного теряем данные, тк диалоги режутся, но не критично
def pairs(conversations):
    kept = []
    index = 0
    while index + 1 < len(conversations):
        question = conversations[index]
        answer = conversations[index + 1]
        if question.get("from") == "human" and answer.get("from") == "gpt":
            kept.append({"from": "human", "value": question.get("value", "")})
            kept.append({"from": "gpt", "value": answer.get("value", "")})
            index += 2
        else:
            index += 1
    return kept


def main():
    with open(SOURCE) as source:
        data = json.load(source)

    groups = {
        (kind, low, high): []
        for kind, ranges in RANGES.items()
        for low, high in ranges
    }
    for item in data:
        conversation = pairs(item.get("conversations") or [])
        prompts = [turn["value"] for turn in conversation if turn["from"] == "human"]
        answers = [turn["value"] for turn in conversation if turn["from"] == "gpt"]
        if not prompts:
            continue
        record = {"conversations": conversation}
        counts = {
            "prompts": [words(prompt) for prompt in prompts],
            "answers": [words(answer) for answer in answers],
        }
        for kind, values in counts.items():
            for low, high in RANGES[kind]:
                if all(low <= count <= high for count in values):
                    groups[(kind, low, high)].append(record)
                    break

    print(len(data))
    for (kind, low, high), records in groups.items():
        path = f"{PREFIX}_{kind}_{low}_{high}.json"
        with open(path, "w") as output:
            json.dump(records, output)
        print(path, len(records))

if __name__ == "__main__":
    main()
