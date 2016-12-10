package com.kazachka.addressbook.controllers;

import java.io.*;
import java.util.List;
import java.util.stream.Collectors;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import org.mybatis.spring.*;

import org.springframework.http.*;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.*;
import javax.validation.*;

import com.fasterxml.jackson.databind.*;

import com.kazachka.addressbook.model.*;

@RestController
public class JsonController {

    @Autowired
    private SqlSessionTemplate session;

    private List<String> getErrorsStringList(List<FieldError> errorList) {
        return errorList
                .stream()
                .map(error ->
                        error.getField() + ": " + error.getDefaultMessage())
                .collect(Collectors.toList());
    }

    @PostMapping(value = "/add", consumes = "application/json")
    @JsonDeserialize(as = Person.class)
    @JsonSerialize
    @ResponseBody
    public ResponseEntity add(@RequestBody @Valid Person person, BindingResult result) {
        if (result.hasErrors()) {
            return new ResponseEntity(
                    getErrorsStringList(result.getFieldErrors()),
                    HttpStatus.BAD_REQUEST);
        }
        if (session.insert("Person.insert", person) > 0) {
            return new ResponseEntity(HttpStatus.OK);
        }
        else {
            return new ResponseEntity(HttpStatus.CONFLICT);
        }
    }

    @PostMapping(value = "/valid", consumes = "application/json")
    @JsonDeserialize(as = Person.class)
    @JsonSerialize
    @ResponseBody
    public ResponseEntity validate(@Valid @RequestBody Person person, BindingResult result)
            throws IOException {
        System.out.println(new ObjectMapper().writeValueAsString(person));
        if(result.hasErrors()) {
            return new ResponseEntity(
                    getErrorsStringList(result.getFieldErrors()),
                    HttpStatus.BAD_REQUEST);
        }
        else {
            return new ResponseEntity(HttpStatus.OK);
        }
    }

    @GetMapping(value = "/get/{id}", produces = "application/json")
    @JsonSerialize(as = Person.class)
    @ResponseBody
    public Person getById(@PathVariable("id") int id) {
        return session.selectOne("Person.selectById", id);
    }

    @PostMapping(value = "/get", produces = "application/json", consumes = "application/json")
    @JsonDeserialize(as = Person.class)
    @JsonSerialize
    @ResponseBody
    public List<Person> getByConditions(@RequestBody Person person) {
        return session.selectList("Person.selectByConditions", person);
    }

    @PutMapping(value = "/update", produces = "application/json")
    @JsonDeserialize(as = Person.class)
    @ResponseBody
    public ResponseEntity update(@RequestBody @Valid Person person, BindingResult result) {
        if (result.hasErrors()) {
            return new ResponseEntity(
                    getErrorsStringList(result.getFieldErrors()),
                    HttpStatus.BAD_REQUEST);
        }
        else if (session.update("Person.update", person) > 0) {
            return new ResponseEntity(HttpStatus.OK);
        }
        else {
            return new ResponseEntity(HttpStatus.NOT_FOUND);
        }
    }

    @DeleteMapping(value = "/delete/{id}")
    @ResponseBody
    public ResponseEntity delete(@PathVariable("id") int id) {
        if (session.delete("Person.delete", id) > 0) {
            return new ResponseEntity(HttpStatus.OK);
        }
        else {
            return new ResponseEntity(HttpStatus.NOT_FOUND);
        }
    }

}
