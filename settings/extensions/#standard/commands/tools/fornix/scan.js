#!/usr/bin/env -S deno run --allow-all

const { run, Timeout, Env, Cwd, Stdin, Stdout, Stderr, Out, Overwrite, AppendTo, zipInto, mergeInto, returnAsString, } = await import(`https://deno.land/x/quickr@0.3.22/main/run.js`)
const { FileSystem } = await import(`https://deno.land/x/quickr@0.3.22/main/file_system.js`)
const { Console, yellow } = await import(`https://deno.land/x/quickr@0.3.22/main/console.js`)


Console.env.NIXPKGS_ALLOW_BROKEN = "1"

// increases resolution over time
function* binaryListOrder(aList, ) {
    const length = aList.length
    const middle = Math.floor(length/2)
    yield aList[middle]
    if (length > 1) {
        const upperItems = binaryListOrder(aList.slice(0,middle))
        const lowerItems = binaryListOrder(aList.slice(middle+1))
        // all the sub-elements
        for (const eachUpper of upperItems) {
            yield eachUpper
            const eachLower = lowerItems.next()
            if (!eachLower.done) {
                yield eachLower.value
            }
        }
    }
}

const allPackgeInfoPath = `./scan/allPackageInfo/`
async function getAllPackageInfo(hash) {
    const path = `${allPackgeInfoPath}/${hash}.json`
    let jsonString = await FileSystem.read(path)
    let output
    try {
        output = JSON.parse(jsonString)
    } catch (error) {
        
    }
    if (jsonString == null || output == null) {
        await run`nix-env -qa --json -I ${`https://github.com/NixOS/nixpkgs/archive/${hash}.tar.gz`} ${Stdout(Overwrite(path))}`
        jsonString = await FileSystem.read(path)
    }
    try {
        return JSON.parse(jsonString)
    } catch (error) {
        console.debug(`path is:`,path)
        throw Error(error)
    }
}

// for single package
async function getPackageJsonFor(packageAttrPath, hash) {
    // nix-env -qaA nixpkgs.python --json -I https://github.com/NixOS/nixpkgs/archive/6c36c4ca061f0c85eed3c96c0b3ecc7901f57bb3.tar.gz
    const jsonString = await run`nix-env -qaA ${packageAttrPath} --json -I ${`https://github.com/NixOS/nixpkgs/archive/${hash}.tar.gz`} ${Stdout(returnAsString)}`
    return JSON.parse(jsonString)[packageAttrPath]
}

function convertPackageInfo(attrName, packageInfo) {
    const output = {
        name: "",
        shortDescription: "",
        longDescription: "",
        versionString: "",
        attributeName: attrName.split("."),
        homepage: "",
        license: "", // full name
        semver: [],
        unfree: false,
        insecure: false,
        broken: false,
        sources: [],
        platforms: [],
    }
    
    if (packageInfo.pname) {
        output.name = packageInfo.pname
    } else if (packageInfo.name && packageInfo.version) {
        output.name = packageInfo.name.slice(0,packageInfo.version.length+1)
    } else if (packageInfo.name) {
        output.name = packageInfo.name.replace(/-.*/, "")
    } else {
        return null
    }
    
    if (packageInfo.version) {
        output.versionString = packageInfo.version
    } else if (packageInfo.name && packageInfo.pname) {
        output.versionString = packageInfo.name.slice(packageInfo.pname+1)
    } else if (packageInfo.name) {
        output.versionString = packageInfo.name.replace(/.+?-/, "")
    } else {
        return null
    }

    const semverMatch = output.versionString.match(/((?:\d+)\.(?:\d+)(?:\.(?:\d+))*)(.+)/)
    if (semverMatch) {
        output.semver = semverMatch[1].split(".").map(each=>each-0)
        const tagIfAny = semverMatch[2]
        if (tagIfAny) {
            output.semver.push(tagIfAny)
        }
    }
    
    output.license = packageInfo.meta.license
    output.shortDescription = packageInfo.meta.description
    output.longDescription  = packageInfo.meta.longDescription
    output.homepage         = packageInfo.meta.homepage
    output.unfree           = packageInfo.meta.unfree
    output.insecure         = packageInfo.meta.insecure
    output.broken           = packageInfo.meta.broken
    output.platforms        = packageInfo.meta.platforms
    
    return output
    // "nixpkgs.python310": {
    //     "name": "python3-3.10.2",
    //     "pname": "python3",
    //     "version": "3.10.2",
    //     "system": "x86_64-darwin",
    //     "meta": {
        //     "available": true,
        //     "broken": false,
        //     "description": "A high-level dynamically-typed programming language",
        //     "homepage": "http://python.org",
        //     "insecure": false,
        //     "license": {
        //         "deprecated": false,
        //         "free": true,
        //         "fullName": "Python Software Foundation License version 2",
        //         "redistributable": true,
        //         "shortName": "psfl",
        //         "spdxId": "Python-2.0",
        //         "url": "https://spdx.org/licenses/Python-2.0.html"
        //     },
        //     "longDescription": "Python is a remarkably powerful dynamic programming language that\nis used in a wide variety of application domains. Some of its key\ndistinguishing features include: clear, readable syntax; strong\nintrospection capabilities; intuitive object orientation; natural\nexpression of procedural code; full modularity, supporting\nhierarchical packages; exception-based error handling; and very\nhigh level dynamic data types.\n",
        //     "maintainers": [
        //         {
        //         "email": "fridh@fridh.nl",
        //         "github": "fridh",
        //         "githubId": 2129135,
        //         "name": "Frederik Rietdijk"
        //         }
        //     ],
        //     "name": "python3-3.10.2",
        //     "outputsToInstall": [
        //         "out"
        //     ],
        //     "platforms": [
        //         "aarch64-linux",
        //         "armv5tel-linux",
        //         "armv6l-linux",
        //         "armv7a-linux",
        //         "armv7l-linux",
        //         "i686-linux",
        //         "m68k-linux",
        //         "mipsel-linux",
        //         "powerpc64-linux",
        //         "powerpc64le-linux",
        //         "riscv32-linux",
        //         "riscv64-linux",
        //         "s390-linux",
        //         "s390x-linux",
        //         "x86_64-linux",
        //         "x86_64-darwin",
        //         "i686-darwin",
        //         "aarch64-darwin",
        //         "armv7a-darwin"
        //     ],
        //     "position": "/nix/store/wkbdshg9bqx62x1pjpmhk6kb9pfrymcw-nixpkgs-22.05pre360843.3eb07eeafb5/nixpkgs/pkgs/development/interpreters/python/cpython/default.nix:494",
        //     "unfree": false,
        //     "unsupported": false
    //     }
    // }
}

const hashJsonPrimitive = (value) => JSON.stringify(value).split("").reduce(
    (hashCode, currentVal) => (hashCode = currentVal.charCodeAt(0) + (hashCode << 6) + (hashCode << 16) - hashCode),
    0
)

const allPackages = {}
async function asyncAddPackageInfo(packageInfo, commitHash) {
    let packageInfoCopy = {...packageInfo}
    packageInfoCopy.sources = []
    const hashValue = hashJsonPrimitive(packageInfoCopy)
    // import data based on hash
    const filePath = `./scan/packages/${packageInfo.name}/${hashValue}.json`
    const info = await FileSystem.info(filePath)
    if (info.isFile) {
        try {
            packageInfo = JSON.parse(await FileSystem.read(filePath))
        } catch (error) {
            console.warn(error)
        }
    }
    
    // create package if doesn't exist
    if (!(packageInfo.name in allPackages)) {
        allPackages[packageInfo.name] = {}
    }
    
    // create hash if needed
    allPackages[packageInfo.name][hashValue] = packageInfo
    // add source
    allPackages[packageInfo.name][hashValue].sources.push({ git: `https://github.com/NixOS/nixpkgs.git`, commit: commitHash })

    await FileSystem.write({
        path: filePath,
        data: JSON.stringify(allPackages[packageInfo.name][hashValue]),
    })
}

const pathToAllCommits = `./scan/allCommits.txt`
async function getPathToAllCommitHashes() {
    console.debug(`writing commits to:`, pathToAllCommits)
    await run`git log --first-parent --date=short --pretty=format:%H ${Stdout(Overwrite(pathToAllCommits))}`
    return pathToAllCommits
}

const progressFile = `./scan/progress.json`
const commitsFile = `./scan/allCommits.json`
let progress
async function* iterateAllCommitHashes() {
    console.log(`reading in progress file`)
    progress = JSON.parse(`${await FileSystem.read(progressFile)}`)
    let allCommits
    if (progress == null) {
        progress = {
            completedHashes: [],
        }
    }
    if (allCommits == null) {
        allCommits = (await FileSystem.read(await getPathToAllCommitHashes())).split("\n")
    }

    for (const each of binaryListOrder(allCommits)) {
        // Skip! (to resume progress)
        if (progress.completedHashes.includes(each)) {
            console.log(`    skipping ${each}`)
            continue
        }
        // otherwise do it
        yield each
        // save that it was done
        await FileSystem.write({ path: progressFile, data: JSON.stringify(progress), })
    }
}


// 
// main algo
// 
const concurrentSize = 30
for await (const commitHash of iterateAllCommitHashes()) {
    console.debug(`commitHash is:`,commitHash)
    try {
        console.log(`    getting all package info`)
        const allPackages = await getAllPackageInfo(commitHash)
        console.log(`    getting package info retrieved`)
        const waitingGroup = []
        const entries = Object.entries(allPackages)
        const numberOfAttributes = entries.length
        const attributesNumberLength = `${numberOfAttributes}`.length
        let loopNumber = 0
        for (const [attrName, packageInfo] of entries) {
            loopNumber += 1
            if (loopNumber % 500 == 0) {
                console.log(`    ${`${loopNumber}`.padStart(attributesNumberLength)}/${entries.length}: ${Math.round((loopNumber/entries.length)*100)}%`)
            }
            const packageFixedInfo = convertPackageInfo(attrName, packageInfo)
            waitingGroup.push(asyncAddPackageInfo(packageFixedInfo, commitHash))
            if (waitingGroup.length > concurrentSize) {
                await Promise.all(waitingGroup)
                waitingGroup.splice(0,Infinity)
            }
        }
        progress.completedHashes.push(commitHash)
    } catch (error) {
        console.warn(`issue on commit: ${commitHash}, `, error)
    }
}