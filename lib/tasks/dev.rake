namespace :dev do
  
  DEFAULT_PASSWORD = 123456

  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do 
    if Rails.env.development?
      show_spinner("Apagando BD...") {%x(rails db:drop)} 
      show_spinner("Criando BD...") {%x(rails db:create)} 
      show_spinner("Migrando BD...") {%x(rails db:migrate)}
      show_spinner("cadastrando o admin padrão...") {%x(rails dev:add_default_admin)}
      show_spinner("cadastrando o admins extras...") {%x(rails dev:add_extra_admins)}
      show_spinner("cadastrando o user padrão...") {%x(rails dev:add_default_user)}
      
    #{} = do - end
    else
      puts "Você não está no ambiente de desenvolvimento!"
    end
  end
  desc "Adicionar o adm padrão!"
  task add_default_admin: :environment do 
    Admin.create!(
      email: 'admin@admin.com.br',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD,
    )
  end

  desc "Adicionar o adms extras!"
  task add_extra_admins: :environment do 
    10.times do |i|
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD,
      )
      end
    end

  desc "Adicionar o user padrão!"
  task add_default_user: :environment do 
    User.create!(
      email: 'user@user.com.br',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD,
    )
  end


    private

    def show_spinner(msg_start, msg_end = "Concluido!")
      spinner = TTY::Spinner.new("[:spinner] #{msg_start}...")
      spinner.auto_spin
      yield
      spinner.success("#{msg_end}")
    end
end
