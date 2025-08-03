# Requirements Document

## Introduction

TaskPay is a mobile application built with Flutter that connects individuals needing small, odd jobs done ("Posters") with school students looking to earn money ("Taskers"). The app facilitates seamless task posting, bidding, completion, and secure in-app payments through an intuitive user interface. The system leverages Appwrite for backend services and Paystack for secure payment processing with an escrow system to protect both parties.

## Requirements

### Requirement 1: User Authentication & Account Management

**User Story:** As a user, I want to securely register and log into the app with multiple authentication options, so that I can access the platform safely and conveniently.

#### Acceptance Criteria

1. WHEN a new user accesses the app THEN the system SHALL provide registration options via email/password and third-party providers through Appwrite authentication
2. WHEN a user attempts to log in THEN the system SHALL authenticate credentials and establish a secure session
3. WHEN a user registers THEN the system SHALL allow them to select their primary role as either "Poster" or "Tasker"
4. WHEN a user wants to switch roles THEN the system SHALL allow role switching within their profile settings
5. IF a user forgets their password THEN the system SHALL provide a secure password reset mechanism

### Requirement 2: User Profile Management

**User Story:** As a user, I want to create and manage my profile with role-specific information, so that other users can make informed decisions about working with me.

#### Acceptance Criteria

1. WHEN a Poster creates their profile THEN the system SHALL store and display past posted tasks, ratings received, and payment methods
2. WHEN a Tasker creates their profile THEN the system SHALL store and display completed tasks, ratings received, skills/services offered, and payment withdrawal methods
3. WHEN a Tasker wants to build trust THEN the system SHALL provide optional student ID verification functionality
4. WHEN profile data is entered THEN the system SHALL securely store all information in Appwrite's database
5. WHEN a user updates their profile THEN the system SHALL validate and save changes in real-time

### Requirement 3: Task Creation & Management

**User Story:** As a Poster, I want to create detailed task postings with all necessary information, so that Taskers can understand and bid on my tasks effectively.

#### Acceptance Criteria

1. WHEN a Poster creates a new task THEN the system SHALL provide form fields for title, description, category, location, budget, deadline, and optional attachments
2. WHEN a Poster uploads attachments THEN the system SHALL store files securely in Appwrite's storage service
3. WHEN a task is created THEN the system SHALL assign it a "Pending" status and make it visible to eligible Taskers
4. WHEN a Poster wants to modify a task THEN the system SHALL allow editing of task details before assignment
5. IF a task has no bids after 48 hours THEN the system SHALL notify the Poster with suggestions for improvement

### Requirement 4: Task Discovery & Filtering

**User Story:** As a Tasker, I want to browse and filter available tasks efficiently, so that I can find opportunities that match my skills and availability.

#### Acceptance Criteria

1. WHEN a Tasker accesses the discover page THEN the system SHALL display available tasks in a clean, card-based layout
2. WHEN a Tasker applies filters THEN the system SHALL filter tasks by category, location, budget range, and deadline
3. WHEN a Tasker searches for tasks THEN the system SHALL provide keyword search functionality across task titles and descriptions
4. WHEN new tasks are posted THEN the system SHALL update the discover page in real-time using Appwrite's real-time functionality
5. WHEN a Tasker views task details THEN the system SHALL display all relevant information including Poster ratings and verification status

### Requirement 5: Bidding & Task Assignment

**User Story:** As a Poster, I want to receive and evaluate bids from Taskers, so that I can select the best candidate for my task.

#### Acceptance Criteria

1. WHEN a task allows bidding THEN the system SHALL enable Taskers to submit bid proposals with custom pricing
2. WHEN a Poster receives bids THEN the system SHALL display all bids with Tasker profiles and ratings
3. WHEN a Poster accepts a bid THEN the system SHALL assign the task to the selected Tasker and notify both parties
4. WHEN a task is assigned THEN the system SHALL update the task status to "Assigned" and remove it from the discover page
5. IF a Poster sets a fixed price THEN the system SHALL allow direct task assignment without bidding

### Requirement 6: Task Status Tracking

**User Story:** As a user, I want to track the progress of my tasks in real-time, so that I stay informed about task completion status.

#### Acceptance Criteria

1. WHEN a task progresses through stages THEN the system SHALL update status to "Pending," "Assigned," "In Progress," "Completed," or "Paid"
2. WHEN task status changes THEN the system SHALL notify both Poster and Tasker using Appwrite's real-time functionality
3. WHEN a Tasker starts work THEN the system SHALL allow them to update status to "In Progress"
4. WHEN a task is completed THEN the system SHALL require confirmation from both parties before proceeding to payment
5. WHEN disputes arise THEN the system SHALL provide a clear dispute resolution process

### Requirement 7: Secure Payment Processing

**User Story:** As a user, I want secure payment processing with escrow protection, so that my financial transactions are safe and both parties are protected.

#### Acceptance Criteria

1. WHEN a Poster initiates payment THEN the system SHALL call an Appwrite Cloud Function to securely interact with Paystack API
2. WHEN payment is processed THEN the system SHALL use Paystack Flutter SDK to launch secure payment UI
3. WHEN payment is successful THEN the system SHALL hold funds in escrow until task completion is confirmed by both parties
4. WHEN Paystack sends webhook events THEN the system SHALL verify transaction signatures and update task status in Appwrite database
5. IF payment fails THEN the system SHALL provide clear error messages and retry options

### Requirement 8: Wallet & Withdrawal System

**User Story:** As a Tasker, I want to manage my earnings through an in-app wallet system, so that I can track income and request withdrawals to my bank account.

#### Acceptance Criteria

1. WHEN a task payment is completed THEN the system SHALL credit the Tasker's in-app wallet with earned amount
2. WHEN a Poster makes payment THEN the system SHALL debit funds from their linked payment method
3. WHEN a Tasker requests withdrawal THEN the system SHALL process the request through a dedicated Appwrite Function
4. WHEN wallet transactions occur THEN the system SHALL maintain detailed transaction history for both users
5. IF withdrawal fails THEN the system SHALL notify the user and provide alternative options

### Requirement 9: Communication System

**User Story:** As a user, I want to communicate with my task partner through secure in-app messaging, so that we can coordinate task details effectively.

#### Acceptance Criteria

1. WHEN users are matched for a task THEN the system SHALL enable real-time messaging between Poster and Tasker
2. WHEN messages are sent THEN the system SHALL use Appwrite's real-time database for instant delivery
3. WHEN important events occur THEN the system SHALL send push notifications for new tasks, bids, status updates, payments, and messages
4. WHEN tasks are completed THEN the system SHALL allow both parties to rate and review each other
5. WHEN ratings are submitted THEN the system SHALL store reviews in Appwrite's database and update user profiles

### Requirement 10: Theme & UI Customization

**User Story:** As a user, I want to choose between light and dark themes, so that I can use the app comfortably in different lighting conditions.

#### Acceptance Criteria

1. WHEN a user accesses theme settings THEN the system SHALL provide options for light theme, dark theme, or system default
2. WHEN light theme is selected THEN the system SHALL apply the specified color scheme with primary color #007AFF and accent color #5856D6
3. WHEN dark theme is selected THEN the system SHALL apply the dark color scheme with primary color #0A84FF and accent color #AF52DE
4. WHEN theme changes THEN the system SHALL update all UI elements immediately without requiring app restart
5. WHEN system theme is selected THEN the system SHALL automatically switch themes based on device settings