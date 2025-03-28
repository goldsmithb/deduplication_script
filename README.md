# Identifying Duplicate S3 objects

Expected headers for input CSV files:
 * `bucket` (The name of the bucket.)
 * `key` (The location of the file in the bucket.  Looks like a path.)
 * `etag` (S3 “etag” field value – Although this is not guaranteed to be an an md5 hash of the file, it often is.  Sometimes it’s a hash of hashes, and in those cases it ends with a hyphen and a number representing the number of file chunks that were hashed.)
* `size` (The size of the file in bytes.)

| bucket   | key     | etag | size (in Bytes) |
| -------- | ------- | ---- | ---- |
| example | exampleS3/home/subdir/file.ext | md5_hash | 30567 |

The script will create multiple CSV files.

All will have the following headers:
 * `object1_s3_uri` (Format: “s3://#{bucket}/#{key}” – This is an S3 URI version of the bucket and key values from CSV 1.  This cell should be blank if no exact or potential match is found that matches to an object in CSV 2.)
 * `object2_s3_uri` (Format: “s3://#{bucket}/#{key}” – This is an S3 URI version of the bucket and key values from CSV 2.  This cell should be blank if no exact or potential match is found that matches to an object in CSV 1.)
 * `object1_etag` (The etag value from CSV 1 for the object identified by the object1_s3_uri value.  Leave blank if object1_s3_uri is blank.)
 * `object2_etag` (The etag value from CSV 2 for the object identified by the object2_s3_uri value.  Leave blank if object2_s3_uri is blank.)
 * `object1_size` (The size value from CSV 1 for the object identified by the object1_s3_uri value.  Leave blank if object1_s3_uri is blank.)
 * `object2_size` (The size value from CSV 2 for the object identified by the object2_s3_uri value.  Leave blank if object2_s3_uri is blank.)
 * `comparison_result` (One of the following values: [`“exact match”`, `“possible match”`, `“no match”`])

The first, `matches.csv`, lists all of the identified duplicate records shared by the two CSVs.



## Example Ruby Script Development Template

This is a quick setup template for ruby scripts.  It includes:

- A main.js file, which is an example entrypoint file for a ruby script.  If you want to, you can rename this to something more relevant to the script you're writing.
- A .ruby-version file to specify what version of Ruby you're using.
- A Gemfile for managing dependencies.
- Zeitwerk for auto-loading classes and modules in the `lib` directory.
- RSpec for testing.
- Some example classes and tests (which you can delete in your local copy).

This project is meant to be downloaded as a zip file rather than cloned, since you'll most likely be using it as the basis for a new project (as opposed to wanting to push commits to the template code repository).

# Getting started

- Download this repository:
  - Option 1: Download as a zip file.
  - Option 2: Clone the repository and then delete the `.git` directory inside your closed copy so that you can initialize a new `.git` repository (with `git init`).
- Update the `.ruby-version` file based on the version of Ruby that you want to use.
- Run `bundle install`
  - Modern installations of ruby come with the `bundler` gem, so this should work as long as you're running `bundle install` in this project's top level directory.
- To try out the base project and make sure it works, run: `ruby ./main.rb`
  - It should print out `Hello!` and `Hello again!`
- To run rspec tests, run: `bundle exec rspec`
  - The tests should pass.

# Development notes

You can add new classes and modules in the `lib` directory and they'll be auto-loaded and available for use in your `main.js` script thanks to Zeitwerk.  In order for this to work, you'll need to name files according to Zeitwerk rules (https://github.com/fxn/zeitwerk).  Here's a quick summary

```
lib/animal.rb                        -> Animal
lib/animals/dog.rb                   -> Animals::Dog
lib/animals/dogs/beagle.rb           -> Animals::Dogs::Beagle
lib/animals/dogs/golden_retriever.rb -> Animals::Dogs::GoldenRetriever
```
