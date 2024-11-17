-- Insert sample data into the "User" table
INSERT INTO "User" ("id", "name", "email", "registeredObjects") VALUES
('user1', 'Alice Johnson', 'alice.johnson@example.com', 0),
('user2', 'Bob Smith', 'bob.smith@example.com', 0),
('user3', 'Charlie Davis', 'charlie.davis@example.com', 0);

-- Insert sample data into the "Poll" table
INSERT INTO "Poll" ("id", "question", "userId", "registrationTimestamp") VALUES
('poll1', 'What is your favorite programming language?', 'user1', '2024-11-17T15:51:16.403838648Z'),
('poll2', 'Which season do you prefer?', 'user2', '2024-11-17T15:51:34.531460345Z'),
('poll3', 'What is your preferred mode of transportation?', 'user3', '2024-11-17T15:51:34.726319386Z'),
('poll4', 'Do you support remote work?', 'user1', '2024-11-17T15:51:35.800877165Z'),
('poll5', 'What is your favorite cuisine?', 'user2', '2024-11-17T15:51:36.634753342Z');

-- Insert sample data into the "Vote" table
INSERT INTO "Vote" ("id", "option", "answers", "pollId") VALUES
('vote1', 'Python', 150, 'poll1'),
('vote2', 'JavaScript', 120, 'poll1'),
('vote3', 'Java', 80, 'poll1'),
('vote4', 'Spring', 60, 'poll1'),
('vote5', 'Spring', 40, 'poll1'),

('vote6', 'Spring', 70, 'poll2'),
('vote7', 'Summer', 200, 'poll2'),
('vote8', 'Autumn', 90, 'poll2'),
('vote9', 'Winter', 50, 'poll2'),

('vote10', 'Car', 180, 'poll3'),
('vote11', 'Bicycle', 60, 'poll3'),
('vote12', 'Public Transport', 100, 'poll3'),
('vote13', 'Walking', 40, 'poll3'),

('vote14', 'Yes', 250, 'poll4'),
('vote15', 'No', 50, 'poll4'),

('vote16', 'Italian', 130, 'poll5'),
('vote17', 'Chinese', 110, 'poll5'),
('vote18', 'Mexican', 90, 'poll5'),
('vote19', 'Indian', 70, 'poll5'),
('vote20', 'Thai', 60, 'poll5');
