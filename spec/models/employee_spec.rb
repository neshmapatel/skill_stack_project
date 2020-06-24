require 'rails_helper'

RSpec.describe Employee, type: :model do

  before do
    @employee = Employee.new(name: 'Example User', email: 'exampleuser@simformsolutions.com', 
                             password: 'foobar', password_confirmation: 'foobar' )
  end

  subject { @employee } 
  it { should respond_to(:name) }
  it { should respond_to(:email) } 
  it { should respond_to(:password_digest) } 
  it { should respond_to(:password) } 
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) } 

  it { should be_valid}
  
  # test to check presence of name and  email
  describe "when name is not present" do
    before { @employee.name = " "}
    it { should_not be_valid }
  end
  describe "when email is not present" do
    before { @employee.email= " "}
    it { should_not be_valid }
  end

  # check email format
  describe "when email format is invalid" do
    it "should be invalid" do
        add =%w[employee@foo,com employeefoo.org employee@foo.com]
        add.each do |invalid_add|
            @employee.email=invalid_add
            expect(@employee).to be_invalid 
        end
    end
  end
  describe "whem email format is valid" do
      it "should be valid" do
          add = %w[employee@simformsolutions.com]
          add.each do |valid_add|
              @employee.email = valid_add
              expect(@employee).to be_valid 
          end
      end
  end

  # check uniqueness of email
  describe "when email is not already taken" do
      before do
          employee_with_same_email = @employee.dup
          employee_with_same_email.save
      end
      it { expect(@employee).to be_invalid }
  end

  # test to check presence of password and password confirmation
  describe "when password is not present" do
    before { @employee.password = @employee.password_confirmation = " "}
    it { should be_invalid }
  end

  # test to match password and password_confirmation
  describe "when password confirmation do not match password" do
    before { @employee.password_confirmation = "mismatch" }
    it { should be_invalid }
  end

  # test to ensure presence of password_confirmation
  describe "when password confirmation is nil" do
    before { @employee.password_confirmation = nil}
    it { should be_invalid }
  end

  # test to authenticate user
  # test to check length of password
  describe "when password is too short" do
    before { @employee.password = @employee.password_confirmation = "a"*5 }
    it { should be_invalid}
  end

  describe "return value of authenticate method" do
    before { @employee }
    let(:found_employee) { Employee.find_by_email(@employee.email) }
    
    describe "with valid password" do
      it { should eq found_employee.authenticate(@employee.password) }
    end
    describe "with invalid" do
      let(:invalid_emp) { found_employee.authenticate("invalid") }
      it { should_not eq invalid_emp }
      specify { invalid_emp.should be_invalid } 
    end
  end

end