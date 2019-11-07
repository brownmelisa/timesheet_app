# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TimesheetApp.Repo.insert!(%TimesheetApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TimesheetApp.Repo
alias TimesheetApp.Users.User
alias TimesheetApp.Jobs.Job
alias TimesheetApp.Timesheets.Timesheet
alias TimesheetApp.Tasks.Task

pw = Argon2.hash_pwd_salt("password1234")

# Insert sample data into User
Repo.insert!(%User{
  name: "Alice Anderson",
  email: "alice@acme.com",
  is_manager: true,
  password_hash: pw
})
Repo.insert!(%User{
  name: "Bob Anderson",
  email: "bob@acme.com",
  is_manager: true,
  password_hash: pw
})
Repo.insert!(%User{
  name: "Carol Anderson",
  email: "carol@acme.com",
  is_manager: false,
  manager_id: 1,
  password_hash: pw })
Repo.insert!(%User{
  name: "Dave Anderson",
  email: "dave@acme.com",
  is_manager: false,
  manager_id: 2,
  password_hash: pw })


# Insert sample data into Jobs
Repo.insert!(%Job{
  job_code: "VAOR-01",
  budget_hours: 20,
  name: "Cyborg Arm",
  description: "(1)",
  user_id: 1
})
Repo.insert!(%Job{
  job_code: "VAOR-02",
  budget_hours: 45,
  name: "Sobriety Pill",
  description: "(1)",
  user_id: 1
})
Repo.insert!(%Job{
  job_code: "VAOR-03",
  budget_hours: 12,
  name: "Rat Cancer",
  description: "(1)",
  user_id: 2
})
Repo.insert!(%Job{
  job_code: "VAOR-04",
  budget_hours: 30,
  name: "Building Maintenance",
  description: "(1)",
  user_id: 2
})
Repo.insert!(%Job{
  job_code: "VAOR-05",
  budget_hours: 45,
  name: "Wrangling Elephants",
  description: "(1)",
  user_id: 2
})


# Insert sample data into Timesheets
Repo.insert!(%Timesheet{
  date: ~D[2018-04-05],
  status: "approved",
  total_hours: 8,
  user_id: 3
})
Repo.insert!(%Timesheet{
  date: ~D[2018-04-05],
  status: "pending",
  total_hours: 6,
  user_id: 4
})
Repo.insert!(%Timesheet{
  date: ~D[2019-10-18],
  status: "rejected",
  total_hours: 8,
  user_id: 3
})


# Insert sample data into Tasks
# Timesheet 1
Repo.insert!(%Task{
  hours_worked: 2,
  note: "sample task1",
  job_id: 1,
  user_id: 3,
  timesheet_id: 1
})
Repo.insert!(%Task{
  hours_worked: 2,
  note: "sample task2",
  job_id: 2,
  user_id: 3,
  timesheet_id: 1
})
Repo.insert!(%Task{
  hours_worked: 2,
  note: "sample task3",
  job_id: 3,
  user_id: 3,
  timesheet_id: 1
})
Repo.insert!(%Task{
  hours_worked: 1,
  note: "sample task4",
  job_id: 4,
  user_id: 3,
  timesheet_id: 1
})
Repo.insert!(%Task{
  hours_worked: 1,
  note: "sample task5",
  job_id: 5,
  user_id: 3,
  timesheet_id: 1
})

# Timesheet2
Repo.insert!(%Task{
  hours_worked: 4,
  note: "arm broken",
  job_id: 1,
  user_id: 4,
  timesheet_id: 2
})
Repo.insert!(%Task{
  hours_worked: 2,
  note: "sample task2",
  job_id: 2,
  user_id: 4,
  timesheet_id: 2
})
Repo.insert!(%Task{
  hours_worked: 4,
  note: "elephants were hungry, went overtime",
  job_id: 5,
  user_id: 4,
  timesheet_id: 2
})


#Timesheet 3
Repo.insert!(%Task{
  hours_worked: 3,
  note: "sample task",
  job_id: 3,
  user_id: 3,
  timesheet_id: 3
})
Repo.insert!(%Task{
  hours_worked: 3,
  note: "sample task",
  job_id: 4,
  user_id: 3,
  timesheet_id: 3
})




#
#lorem_ipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.
#  Quisque maximus metus nec enim molestie mollis. Curabitur nec tellus mi.
#  Vivamus mi est, sodales nec finibus at, eleifend ac ligula. Praesent semper
#  ultrices felis in tempus. Integer sit amet dui eget ante efficitur porttitor.
#  Curabitur lorem diam, vulputate sit amet odio at, lobortis ornare nisl.
#  Aenean dignissim commodo semper. Curabitur feugiat facilisis aliquet.
#  Class aptent taciti sociosqu ad litora torquent per conubia nostra,
#  per inceptos himenaeos. Proin id mauris tincidunt, viverra nisl quis, ornare turpis.
#
#  Morbi suscipit leo et purus pretium condimentum. Morbi ut maximus sem.
#  Ut vel felis nec erat dapibus auctor finibus quis libero. Aenean massa tellus,
#  auctor sit amet egestas sit amet, ornare sed mauris. Aliquam pharetra nisl non
#  commodo elementum. Fusce vehicula pretium tortor, ut tempor purus tristique vel.
#  Vivamus vehicula consectetur nisl, eget egestas leo feugiat eu.
#
#  Praesent placerat ac dolor condimentum suscipit. Donec vel metus eget quam blandit maximus.
#  Sed a ligula est. Fusce in libero dolor. Aenean quis elementum justo, ut fermentum odio.
#  Cras bibendum sapien mauris, sed porttitor eros rhoncus vel. Donec sed diam ac mi dignissim
#  suscipit eget at erat. Quisque nec ligula semper, dapibus quam viverra, mattis nisi.
#  Proin facilisis vitae erat vel luctus. Aenean fermentum vulputate metus ac finibus.
#  Pellentesque vulputate interdum urna, sit amet luctus metus maximus quis. Quisque eu
#  neque condimentum, semper ante efficitur, vulputate libero. Praesent non sodales ante,
#  et volutpat augue. Etiam at tellus at quam interdum bibendum."
#

