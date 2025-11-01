
-- Dummy data for universities, faculties, and study programs

-- Universities
INSERT INTO university (id, name) VALUES (1, 'Comenius University in Bratislava');
INSERT INTO university (id, name) VALUES (2, 'Slovak University of Technology in Bratislava');
INSERT INTO university (id, name) VALUES (3, 'University of Žilina');

-- Faculties for Comenius University
INSERT INTO faculty (id, name, university_id) VALUES (1, 'Faculty of Mathematics, Physics and Informatics', 1);
INSERT INTO faculty (id, name, university_id) VALUES (2, 'Faculty of Medicine', 1);
INSERT INTO faculty (id, name, university_id) VALUES (3, 'Faculty of Law', 1);

-- Faculties for Slovak University of Technology
INSERT INTO faculty (id, name, university_id) VALUES (4, 'Faculty of Informatics and Information Technologies', 2);
INSERT INTO faculty (id, name, university_id) VALUES (5, 'Faculty of Electrical Engineering and Information Technology', 2);
INSERT INTO faculty (id, name, university_id) VALUES (6, 'Faculty of Civil Engineering', 2);

-- Faculties for University of Žilina
INSERT INTO faculty (id, name, university_id) VALUES (7, 'Faculty of Management Science and Informatics', 3);
INSERT INTO faculty (id, name, university_id) VALUES (8, 'Faculty of Electrical Engineering and Information Technology', 3);

-- Study Programs for Faculty of Mathematics, Physics and Informatics (Comenius)
INSERT INTO study_program (id, name, code, faculty_id) VALUES (1, 'Computer Science', 'CS', 1);
INSERT INTO study_program (id, name, code, faculty_id) VALUES (2, 'Applied Mathematics', 'AM', 1);
INSERT INTO study_program (id, name, code, faculty_id) VALUES (3, 'Physics', 'PH', 1);

-- Study Programs for Faculty of Medicine (Comenius)
INSERT INTO study_program (id, name, code, faculty_id) VALUES (4, 'General Medicine', 'GM', 2);
INSERT INTO study_program (id, name, code, faculty_id) VALUES (5, 'Dentistry', 'DEN', 2);

-- Study Programs for Faculty of Law (Comenius)
INSERT INTO study_program (id, name, code, faculty_id) VALUES (6, 'Law', 'LAW', 3);

-- Study Programs for Faculty of Informatics and Information Technologies (STU)
INSERT INTO study_program (id, name, code, faculty_id) VALUES (7, 'Software Engineering', 'SE', 4);
INSERT INTO study_program (id, name, code, faculty_id) VALUES (8, 'Information Systems', 'IS', 4);
INSERT INTO study_program (id, name, code, faculty_id) VALUES (9, 'Artificial Intelligence', 'AI', 4);

-- Study Programs for Faculty of Electrical Engineering and Information Technology (STU)
INSERT INTO study_program (id, name, code, faculty_id) VALUES (10, 'Applied Informatics', 'API', 5);
INSERT INTO study_program (id, name, code, faculty_id) VALUES (11, 'Telecommunications', 'TEL', 5);

-- Study Programs for Faculty of Civil Engineering (STU)
INSERT INTO study_program (id, name, code, faculty_id) VALUES (12, 'Civil Engineering', 'CE', 6);
INSERT INTO study_program (id, name, code, faculty_id) VALUES (13, 'Architecture', 'ARCH', 6);

-- Study Programs for Faculty of Management Science and Informatics (Žilina)
INSERT INTO study_program (id, name, code, faculty_id) VALUES (14, 'Business Informatics', 'BI', 7);
INSERT INTO study_program (id, name, code, faculty_id) VALUES (15, 'Management Information Systems', 'MIS', 7);

-- Study Programs for Faculty of Electrical Engineering and Information Technology (Žilina)
INSERT INTO study_program (id, name, code, faculty_id) VALUES (16, 'Automation and Robotics', 'AR', 8);
INSERT INTO study_program (id, name, code, faculty_id) VALUES (17, 'Electronics', 'ELEC', 8);