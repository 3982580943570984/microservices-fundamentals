import ballerina/http;

type Poll readonly & record {|
    string question;
    string[] options;
    map<int> votes;
|};

type PollEntry readonly & record {|
    int id;
    Poll poll;
|};

table<PollEntry> key(id) pollEntries = table [
    {
        id: 1,
        poll: {
            question: "Ваш любимый язык программирования?",
            options: ["Python", "Java", "JavaScript"],
            votes: {"0": 10, "1": 5, "2": 3}
        }
    },
    {
        id: 2,
        poll: {
            question: "Какой ваш любимый цвет?",
            options: ["Красный", "Зеленый", "Синий"],
            votes: {"0": 7, "1": 2, "2": 4}
        }
    },
    {
        id: 3,
        poll: {
            question: "Какой вид спорта вам больше всего нравится?",
            options: ["Футбол", "Баскетбол", "Теннис"],
            votes: {"0": 8, "1": 6, "2": 5}
        }
    }
];

service / on new http:Listener(8080) {
    # Получить все голосования.
    # + return - Массив объектов `PollEntry`.
    resource function get polls() returns PollEntry[] {
        return pollEntries.toArray();
    }

    # Получить голосование по идентификатору.
    #
    # + id - Целочисленный идентификатор голосования.
    # + return - Объект `PollEntry` или код ответа `404 Not Found`, если голосование не найдено.
    resource function get polls/[int id]() returns PollEntry|http:NotFound {
        match pollEntries.hasKey(id) {
            true => {
                return pollEntries.get(id);
            }
            false|_ => {
                return http:NOT_FOUND;
            }
        }
    }

    # Добавить новое голосование.
    #
    # + poll - Объект типа `Poll`, представляющий новое голосование.
    # + return - Объект `PollEntry`, представляющий добавленное голосование с новым идентификатором.
    resource function post polls(@http:Payload Poll poll) returns PollEntry {
        PollEntry pollEntry = {id: pollEntries.nextKey(), poll: poll};
        pollEntries.add(pollEntry);
        return pollEntry;
    }

    # Обновить существующее голосование (`UPSERT - update or insert`).
    #
    # + id - Целочисленный идентификатор голосования.
    # + poll - Объект типа `Poll`, представляющий обновлённое голосование.
    # + return - Объект `PollEntry`, представляющий обновлённое (или добавленное) голосование.
    resource function put polls/[int id](@http:Payload Poll poll) returns PollEntry {
        PollEntry pollEntry = {id: id, poll: poll};
        pollEntries.put(pollEntry);
        return pollEntry;
    }

    # Удалить голосование.
    #
    # + id - Целочисленный идентификатор голосования.
    # + return - Объект `PollEntry`, представляющий удалённое голосование, или код ответа `404 Not Found`, если голосование не найдено.
    resource function delete polls/[int id]() returns PollEntry|http:NotFound {
        match pollEntries.hasKey(id) {
            true => {
                return pollEntries.remove(id);
            }
            false|_ => {
                return http:NOT_FOUND;
            }
        }
    }
}
