require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize(name, grade, id=nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
        )
        SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
      SQL
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
     sql = <<-SQL
       INSERT INTO students (name, grade)
       VALUES (?, ?)
     SQL
     DB[:conn].execute(sql, self.name, self.grade)
     @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end

  # This class method takes an argument of an array.
  # When we call this method we will pass it the array that is the row returned
  # from the database by the execution of a SQL query. We can anticipate that
  # this array will contain three elements in this order: the id, name and grade
  # of a student.

  # The .new_from_db method uses these three array elements to create a new Student object with these attributes.
  def self.new_from_db(student)
    #Student.new(student[], student[], student[])
  end
end
