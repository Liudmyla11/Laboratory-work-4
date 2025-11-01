CREATE TABLE UserSinger (
    user_id INT,
    name VARCHAR(100),
    email VARCHAR(80),
    phone VARCHAR(20),
    preferences VARCHAR(500),
    allergies VARCHAR(500),
    desired_calories INT,
    goals VARCHAR(500)
);

CREATE TABLE Budget (
    budget_id INT,
    amount NUMERIC(10,2),
    type_period VARCHAR(20),
    user_id INT
);

CREATE TABLE MealPlan (
    mealplan_id INT,
    type_period VARCHAR(20),
    meals_count INT,
    total_cost NUMERIC(10,2),
    budget_fit VARCHAR(10),
    user_id INT,
    budget_id INT
);

CREATE TABLE Recipe (
    recipe_id INT,
    name VARCHAR(100),
    instructions VARCHAR(2000),
    approx_calories INT,
    approx_cost NUMERIC(10,2)
);

CREATE TABLE Ingredient (
    ingredient_id INT,
    name VARCHAR(100),
    has_allergen CHAR(3)
);

CREATE TABLE Recipe_Ingredient (
    recipe_id INT,
    ingredient_id INT,
    amount NUMERIC(7,2),
    unit VARCHAR(10)
);

CREATE TABLE MealPlan_Recipe (
    mealplan_id INT,
    recipe_id INT
);

CREATE TABLE NutritionRecommendation (
    recommendation_id INT,
    text VARCHAR(500),
    saving_score NUMERIC(7,2),
    mealplan_id INT
);

CREATE TABLE Application (
    application_id INT,
    personal_data VARCHAR(100),
    contact VARCHAR(80),
    category VARCHAR(100),
    consent CHAR(3),
    user_id INT
);

CREATE TABLE ContestTask (
    task_id INT,
    description VARCHAR(300),
    requirements VARCHAR(1000),
    file_format CHAR(4),
    max_duration INT
);

CREATE TABLE Submission (
    submission_id INT,
    file_name VARCHAR(150),
    file_type CHAR(4),
    upload_date DATE,
    notes VARCHAR(500),
    application_id INT,
    task_id INT
);

CREATE TABLE JuryMember (
    jury_id INT,
    name VARCHAR(100),
    specialization VARCHAR(200)
);

CREATE TABLE JuryReview (
    review_id INT,
    score INT,
    comments VARCHAR(1000),
    summary VARCHAR(500),
    jury_id INT,
    submission_id INT
);

ALTER TABLE UserSinger
    ALTER COLUMN name SET NOT NULL,
    ALTER COLUMN email SET NOT NULL;

ALTER TABLE Budget
    ALTER COLUMN amount SET NOT NULL,
    ALTER COLUMN type_period SET NOT NULL,
    ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE MealPlan
    ALTER COLUMN type_period SET NOT NULL,
    ALTER COLUMN meals_count SET NOT NULL,
    ALTER COLUMN total_cost SET NOT NULL,
    ALTER COLUMN budget_fit SET NOT NULL,
    ALTER COLUMN user_id SET NOT NULL,
    ALTER COLUMN budget_id SET NOT NULL;

ALTER TABLE Recipe
    ALTER COLUMN name SET NOT NULL;

ALTER TABLE Ingredient
    ALTER COLUMN name SET NOT NULL;

ALTER TABLE Application
    ALTER COLUMN personal_data SET NOT NULL,
    ALTER COLUMN contact SET NOT NULL,
    ALTER COLUMN consent SET NOT NULL,
    ALTER COLUMN user_id SET NOT NULL;

ALTER TABLE ContestTask
    ALTER COLUMN description SET NOT NULL,
    ALTER COLUMN file_format SET NOT NULL;

ALTER TABLE Submission
    ALTER COLUMN file_name SET NOT NULL,
    ALTER COLUMN file_type SET NOT NULL,
    ALTER COLUMN application_id SET NOT NULL,
    ALTER COLUMN task_id SET NOT NULL;

ALTER TABLE JuryMember
    ALTER COLUMN name SET NOT NULL;

ALTER TABLE UserSinger ADD CONSTRAINT pk_user PRIMARY KEY (user_id);
ALTER TABLE Budget ADD CONSTRAINT pk_budget PRIMARY KEY (budget_id);
ALTER TABLE MealPlan ADD CONSTRAINT pk_mealplan PRIMARY KEY (mealplan_id);
ALTER TABLE Recipe ADD CONSTRAINT pk_recipe PRIMARY KEY (recipe_id);
ALTER TABLE Ingredient ADD CONSTRAINT pk_ingredient PRIMARY KEY (ingredient_id);
ALTER TABLE Recipe_Ingredient ADD CONSTRAINT pk_recipe_ingredient PRIMARY KEY (recipe_id, ingredient_id);
ALTER TABLE MealPlan_Recipe ADD CONSTRAINT pk_mealplan_recipe PRIMARY KEY (mealplan_id, recipe_id);
ALTER TABLE NutritionRecommendation ADD CONSTRAINT pk_nutrition PRIMARY KEY (recommendation_id);
ALTER TABLE Application ADD CONSTRAINT pk_application PRIMARY KEY (application_id);
ALTER TABLE ContestTask ADD CONSTRAINT pk_task PRIMARY KEY (task_id);
ALTER TABLE Submission ADD CONSTRAINT pk_submission PRIMARY KEY (submission_id);
ALTER TABLE JuryMember ADD CONSTRAINT pk_jury PRIMARY KEY (jury_id);
ALTER TABLE JuryReview ADD CONSTRAINT pk_juryreview PRIMARY KEY (review_id);

ALTER TABLE Budget
    ADD CONSTRAINT fk_budget_user FOREIGN KEY (user_id) REFERENCES UserSinger(user_id);

ALTER TABLE MealPlan
    ADD CONSTRAINT fk_mealplan_user FOREIGN KEY (user_id) REFERENCES UserSinger(user_id),
    ADD CONSTRAINT fk_mealplan_budget FOREIGN KEY (budget_id) REFERENCES Budget(budget_id);

ALTER TABLE Recipe_Ingredient
    ADD CONSTRAINT fk_ri_recipe FOREIGN KEY (recipe_id) REFERENCES Recipe(recipe_id),
    ADD CONSTRAINT fk_ri_ingredient FOREIGN KEY (ingredient_id) REFERENCES Ingredient(ingredient_id);

ALTER TABLE MealPlan_Recipe
    ADD CONSTRAINT fk_mpr_mealplan FOREIGN KEY (mealplan_id) REFERENCES MealPlan(mealplan_id),
    ADD CONSTRAINT fk_mpr_recipe FOREIGN KEY (recipe_id) REFERENCES Recipe(recipe_id);

ALTER TABLE NutritionRecommendation
    ADD CONSTRAINT fk_nr_mealplan FOREIGN KEY (mealplan_id) REFERENCES MealPlan(mealplan_id);

ALTER TABLE Application
    ADD CONSTRAINT fk_app_user FOREIGN KEY (user_id) REFERENCES UserSinger(user_id);

ALTER TABLE Submission
    ADD CONSTRAINT fk_sub_application FOREIGN KEY (application_id) REFERENCES Application(application_id),
    ADD CONSTRAINT fk_sub_task FOREIGN KEY (task_id) REFERENCES ContestTask(task_id);

ALTER TABLE JuryReview
    ADD CONSTRAINT fk_jr_jurymember FOREIGN KEY (jury_id) REFERENCES JuryMember(jury_id),
    ADD CONSTRAINT fk_jr_submission FOREIGN KEY (submission_id) REFERENCES Submission(submission_id);

ALTER TABLE UserSinger
    ADD CONSTRAINT chk_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    ADD CONSTRAINT chk_phone CHECK (phone ~ '^\+380\d{9}$'),
    ADD CONSTRAINT chk_desired_calories CHECK (desired_calories > 0);

ALTER TABLE Budget
    ADD CONSTRAINT chk_budget_amount CHECK (amount > 0),
    ADD CONSTRAINT chk_budget_type_period CHECK (type_period IN ('щоденний','щотижневий'));

ALTER TABLE MealPlan
    ADD CONSTRAINT chk_mealplan_type_period CHECK (type_period IN ('щоденний','щотижневий','щомісячний')),
    ADD CONSTRAINT chk_meals_count CHECK (meals_count > 0),
    ADD CONSTRAINT chk_total_cost CHECK (total_cost >= 0),
    ADD CONSTRAINT chk_budget_fit CHECK (budget_fit IN ('норма','перевищує'));

ALTER TABLE Recipe
    ADD CONSTRAINT chk_approx_calories CHECK (approx_calories > 0),
    ADD CONSTRAINT chk_approx_cost CHECK (approx_cost >= 0);

ALTER TABLE Ingredient
    ADD CONSTRAINT chk_has_allergen CHECK (has_allergen IN ('так','ні'));

ALTER TABLE Recipe_Ingredient
    ADD CONSTRAINT chk_amount CHECK (amount > 0);

ALTER TABLE NutritionRecommendation
    ADD CONSTRAINT chk_saving_score CHECK (saving_score >= 0);

ALTER TABLE Application
    ADD CONSTRAINT chk_contact CHECK (contact ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    ADD CONSTRAINT chk_consent CHECK (consent IN ('так','ні'));

ALTER TABLE ContestTask
    ADD CONSTRAINT chk_file_format CHECK (file_format IN ('mp3','mp4','pdf','jpg')),
    ADD CONSTRAINT chk_max_duration CHECK (max_duration > 0);

ALTER TABLE Submission
    ADD CONSTRAINT chk_file_type CHECK (file_type IN ('mp3','mp4','pdf','jpg'));

ALTER TABLE JuryReview
    ADD CONSTRAINT chk_score CHECK (score BETWEEN 0 AND 100);
